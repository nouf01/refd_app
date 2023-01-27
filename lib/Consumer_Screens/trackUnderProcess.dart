// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/ConsumerNavigation.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/Consumer_Screens/track.dart';
import 'package:refd_app/Consumer_Screens/trackCancelled.dart';
import 'package:refd_app/Consumer_Screens/trackWaiting.dart';
import 'package:refd_app/Provider_Screens/timeLineWidget.dart';
import 'package:timelines/timelines.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class trackUnderProcess extends StatefulWidget {
  Order_object order;
  trackUnderProcess({super.key, required this.order});
  @override
  _trackUnderProcessState createState() => _trackUnderProcessState();
}

class _trackUnderProcessState extends State<trackUnderProcess> {
  Timer? timer;

  DateTime? target;
  String timeLeft = "Timer    ";
  bool running = true;
  Database db = Database();
  bool isExpired = false;
  List<DailyMenu_Item>? orderItems;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? orderStream;

  _initTimer() async {
    var remainingTimeFromDB =
        await db.getOrderRemainingTimer(widget.order.getorderID);
    target = DateTime.fromMillisecondsSinceEpoch(remainingTimeFromDB);
    //target = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('target'));

    if (target!.isBefore(DateTime.now())) {
      print(
          'Yaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaay');
      setState(() {
        timeLeft = 'Timer           ';
        isExpired = true;
      });
      print(timeLeft);
    } else {
      executeTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
    _initTimer();
  }

  Future<void> _initRetrieval() async {
    orderStream = await FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.order.getorderID)
        .snapshots();
    orderItems = await db.retrieve_Order_Items(widget.order.getorderID);
    setState(() {});
  }

  void dispose() {
    print('********************* in Dispose');
    //db.setOrderTimer(widget.order.getorderID, target!.millisecondsSinceEpoch);
    //prefs.setInt('target', target.millisecondsSinceEpoch);
    running = false;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => ConsumerNavigation(choosedIndex: 2)),
      (Route<dynamic> route) => false,
    );
    super.dispose();
  }

  void executeTimer() async {
    while (running) {
      setState(() {
        timeLeft = DateTime.now().isAfter(target!)
            ? 'Timer   '
            : target!.difference(DateTime.now()).toString();
      });
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: orderStream,
        builder: (BuildContext context,
            AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.data == null) {
            return CircularProgressIndicator();
          }
          String status = snapshot.data!.get('status');
          String theID = snapshot.data!.get('orderID');
          int isByProv = snapshot.data!.get('isCancelledByProv');
          if (status == OrderStatus.canceled.toString()) {
            orderStream = null;
            return trackCancelled(orderID: theID, cancelByProv: isByProv);
          } else if (status == OrderStatus.waitingForPickUp.toString()) {
            orderStream = null;
            return trackWaiting(orderID: theID);
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TimeLineStatus(
                    whichStatus: 0,
                  ),
                  SizedBox(height: 50),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    SizedBox(width: 30),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: buildTimer()),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Wait for ${widget.order.getProviderName} \n to accepet your order',
                        style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ]),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: ListTile(
                            //contentPadding: EdgeInsets.all(5.0),
                            leading:
                                Image.network(widget.order.getProviderLogo),
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return bottomOrderDetails();
                                  });
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            isThreeLine: true,
                            title: Text('${widget.order.getProviderName}'),
                            subtitle: Text(
                                'Order #${widget.order.getorderID}\n${widget.order.getdate.toString().substring(0, 16)}'),
                            trailing: IconButton(
                              iconSize: 30.0,
                              icon: Icon(
                                Icons.arrow_drop_down_circle_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return bottomOrderDetails();
                                    });
                              },
                            ))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Container(
                      height: 200,
                      child: Image.network(
                          'https://firebasestorage.googleapis.com/v0/b/refd-d5769.appspot.com/o/GoogleMapTA.webp?alt=media&token=b524dd01-c9fd-4ddc-ab76-565ca5cc6a92'),
                    ),
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll<Color>(
                            Color.fromARGB(255, 246, 77, 65)),
                        fixedSize:
                            MaterialStatePropertyAll<Size>(Size(200.0, 20.0)),
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  title: Text("Confirm Cancellation"),
                                  content: Text(
                                      "Do you want to cancel the current order?"),
                                  actions: [
                                    ElevatedButton(
                                        child: Text("Yes Cancel"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Color.fromARGB(255, 175, 91, 76),
                                        ),
                                        onPressed: () async {
                                          changeOrderStatus();
                                          db.updateOrderInfo(
                                              widget.order.getorderID,
                                              {'isCancelledByProv': 0});
                                          db.returnItemsToDailyMenu(orderItems!,
                                              widget.order.get_ProviderID);
                                          _sendMessage();
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Scaffold(
                                                    backgroundColor:
                                                        Colors.white,
                                                    appBar: AppBar(
                                                      title: const Text(
                                                          'Order Status'),
                                                      backgroundColor:
                                                          Color.fromARGB(255,
                                                              88, 207, 108),
                                                      leading: IconButton(
                                                        icon: Icon(
                                                            Icons.arrow_back),
                                                        onPressed: () {
                                                          Navigator
                                                              .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ConsumerNavigation(
                                                                        choosedIndex:
                                                                            2)),
                                                            (Route<dynamic>
                                                                    route) =>
                                                                false,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    body: trackCancelled(
                                                      orderID: widget
                                                          .order.getorderID,
                                                      cancelByProv: 0,
                                                    )),
                                              ));
                                        }),
                                    ElevatedButton(
                                        child: Text("No"),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color.fromARGB(
                                              255, 108, 114, 108),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        })
                                  ]);
                            });
                      },
                      child: const Text(
                        'Cancel Order',
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            );
          }
        });
  }

  changeOrderStatus() {
    Database db = Database();
    db.updateOrderInfo(
        widget.order.getorderID, {'status': OrderStatus.canceled.toString()});
  }

  Widget buildTimer() {
    return SizedBox(
        child: Text(
      '${timeLeft.substring(0, 7)}',
      style: const TextStyle(
          fontSize: 28, color: Color(0xFF66CDAA), fontWeight: FontWeight.bold),
    ));
  }

  Widget bottomOrderDetails() {
    return Container(
        height: 700,
        child: Column(
          children: [
            Container(
              child: ListTile(
                  //contentPadding: EdgeInsets.all(5.0),
                  leading: Image.network(widget.order.getProviderLogo),
                  onTap: () {},
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  title: Text('${widget.order.getProviderName}'),
                  subtitle: Text(
                      'Order #${widget.order.getorderID}\n${widget.order.getdate.toString().substring(0, 16)}'),
                  trailing: IconButton(
                    iconSize: 30.0,
                    icon: Icon(
                      Icons.copy,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Clipboard.setData(
                              ClipboardData(text: widget.order.getorderID))
                          .then((_) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Order Number copied to clipboard")));
                      });
                    },
                  )),
            ),
            Divider(thickness: 2),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 0.1),
                  itemCount: orderItems!.length,
                  padding: EdgeInsets.all(4),
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 0,
                      child: Container(
                        margin: EdgeInsets.all(4.0),
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "${orderItems![index].getChoosedCartQuantity} x ${orderItems![index].getItem().get_name()} ",
                                // maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                            ),
                            Text(
                              (orderItems![index].getPriceAfetr_discount *
                                      orderItems![index].getChoosedCartQuantity)
                                  .toString(),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
            Divider(thickness: 2),
            Container(
                color: Colors.white,
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16,
                  bottom: 8.0,
                  top: 4.0,
                ),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Total: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            widget.order.get_total.toStringAsFixed(2),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          Text(
                            "Total is include VAT",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    height: 20,
                    thickness: 1,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                ]))
          ],
        ));
  }

  Future _sendMessage() async {
    String providerToken = (await FirebaseFirestore.instance
            .collection('Providers')
            .doc(widget.order.get_ProviderID)
            .get())
        .data()!['token'];
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": [providerToken],
      "messageTitle": "Order ${widget.order.getorderID} is canceled",
      "messageBody":
          'Order ${widget.order.getorderID} is canceled by the consumer'
    });

    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }
}
