// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/chat.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';
import 'package:refd_app/Provider_Screens/pickedUp.dart';
import 'package:refd_app/Provider_Screens/timeLineWidget.dart';
import 'package:timelines/timelines.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'canceled.dart';

class WaitingForPickUp extends StatefulWidget {
  Order_object order;
  WaitingForPickUp({super.key, required this.order});
  @override
  _WaitingForPickUpState createState() => _WaitingForPickUpState();
}

class _WaitingForPickUpState extends State<WaitingForPickUp> {
  Timer? timer;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? orderStream;
  DateTime? target;
  String timeLeft = "Timer";
  bool running = true;
  Database db = Database();
  bool isExpired = false;
  List<DailyMenu_Item>? orderItems;
  Consumer? consumer;
  Stream<types.Room>? roomStream;
  LoggedProvider log = LoggedProvider();

  _initTimer() async {
    var remainingTimeFromDB =
        await db.getOrderRemainingTimer(widget.order.getorderID);
    target = DateTime.fromMillisecondsSinceEpoch(remainingTimeFromDB);

    if (target!.isBefore(DateTime.now())) {
      setState(() {
        timeLeft = 'Expired';
        isExpired = true;
        checkPickUp(widget.order.getorderID);
      });
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
    consumer = Consumer.fromDocumentSnapshot(
        await db.searchForConsumer(widget.order.get_consumerID));
    roomStream = getRoom(widget.order.getRoomID);
    setState(() {});
  }

  void dispose() {
    print('********************* in Dispose');
    //db.setOrderTimer(widget.order.getorderID, target!.millisecondsSinceEpoch);
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProviderNavigation(choosedIndex: 0)),
    );
    running = false;
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
            print('Hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
            return CircularProgressIndicator();
          }
          String status = snapshot.data!.get('status');
          String theID = snapshot.data!.get('orderID');
          int isByProv = snapshot.data!.get('isCancelledByProv');
          if (status == OrderStatus.canceled.toString()) {
            orderStream = null;
            return Canceled(order: widget.order, cancelByProv: isByProv);
          } else if (status == OrderStatus.pickedUp.toString()) {
            orderStream = null;
            return pickedUp(order: widget.order);
          } else {
            if (consumer == null) {
              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            }
            int remTime = snapshot.data!.get('remainingTimer');
            _initTimer();
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TimeLineStatus(
                    whichStatus: 1,
                  ),
                  SizedBox(height: 50),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: buildTimer()),
                      ]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'The consumer should pick up the order within 45 minutes\n if the timer expired the order will be canceled',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0)),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 176, 176, 176)
                                  .withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                              color: Color.fromARGB(255, 212, 212, 212)),
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
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color.fromARGB(255, 176, 176, 176)
                                  .withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(
                              color: Color.fromARGB(255, 212, 212, 212)),
                        ),
                        child: ListTile(
                            //contentPadding: EdgeInsets.all(5.0),
                            leading: Image.network(
                                'https://firebasestorage.googleapis.com/v0/b/refd-d5769.appspot.com/o/User-avatar.svg.png?alt=media&token=5b494d57-6154-4fb3-a670-f454f6b77cc3'),
                            onTap: () {},
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            isThreeLine: false,
                            title: Text('${consumer!.get_name()}'),
                            subtitle: Text('  '),
                            trailing: StreamBuilder<types.Room>(
                              stream: roomStream,
                              builder: (context, snapshot) {
                                return IconButton(
                                  iconSize: 30.0,
                                  icon: Icon(
                                    Icons.chat,
                                    color: Color(0xFF89CDA7),
                                  ),
                                  onPressed: () async {
                                    var theRoom = snapshot.data!;
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                      builder: (_) => ChatPage(
                                        room: theRoom,
                                      ),
                                    ));
                                  },
                                );
                              },
                            ))),
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Color(0xFF89CDA7)),
                        fixedSize:
                            MaterialStatePropertyAll<Size>(Size(200.0, 20.0)),
                      ),
                      onPressed: () {
                        //change the page to picked up page
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Confirm pick up",
                              ),
                              content: const Text(
                                "Confirm that the consumer has picked up the order",
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text("Confirm"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF89CDA7),
                                  ),
                                  onPressed: () {
                                    //change order status to picked up
                                    changeOrderStatus();
                                    //add To Total Sales
                                    db.updateTotalSales(log.getEmailOnly(),
                                        widget.order.get_total);
                                    //add to Total meals
                                    db.updateMeals(log.getEmailOnly());
                                    //for all items increment num of pick up
                                    db.updateNumOfPick(orderItems!);
                                    //go to the next status page
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                              backgroundColor: Colors.white,
                                              appBar: AppBar(
                                                title:
                                                    const Text('Order Status'),
                                                backgroundColor:
                                                    Color(0xFF66CDAA),
                                                leading: IconButton(
                                                  icon: Icon(Icons.arrow_back),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProviderNavigation(
                                                                choosedIndex: 0,
                                                              )),
                                                    );
                                                  },
                                                ),
                                              ),
                                              body: pickedUp(
                                                order: widget.order,
                                              ))),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        //Notification to the user that his pick up is confirmed
                        _sendMessage(
                            consumerEmail: widget.order.get_consumerID,
                            provName: widget.order.getProviderName,
                            orderID: widget.order.getorderID);
                      },
                      child: const Text(
                        'Confirm Pick Up',
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
        widget.order.getorderID, {'status': OrderStatus.pickedUp.toString()});
  }

  Widget buildTimer() {
    return SizedBox(
        child: Text(
      '${timeLeft.substring(2, 7)}',
      style: const TextStyle(
          fontSize: 35, color: Color(0xFF89CDA7), fontWeight: FontWeight.bold),
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

  static Future _sendMessage(
      {required String consumerEmail,
      required String provName,
      required String orderID}) async {
    String consumerToken = (await FirebaseFirestore.instance
            .collection('Consumers')
            .doc(consumerEmail)
            .get())
        .data()!['token'];
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": [consumerToken],
      "messageTitle": "Your pick up from ${provName} is confirmed",
      "messageBody": 'Thank you for your choosing us!'
    });

    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }

  Stream<types.Room> getRoom(String roomId) {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .snapshots()
        .asyncMap(
          (doc) => processRoomDocument(
            doc,
            FirebaseAuth.instance.currentUser!,
            FirebaseFirestore.instance,
            'users',
          ),
        );
  }

  Future<types.Room> processRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    User firebaseUser,
    FirebaseFirestore instance,
    String usersCollectionName,
  ) async {
    final data = doc.data()!;

    data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
    data['id'] = doc.id;
    data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

    var imageUrl = data['imageUrl'] as String?;
    var name = data['name'] as String?;
    final type = data['type'] as String;
    final userIds = data['userIds'] as List<dynamic>;
    final userRoles = data['userRoles'] as Map<String, dynamic>?;

    final users = await Future.wait(
      userIds.map(
        (userId) => fetchUser(
          instance,
          userId as String,
          usersCollectionName,
          role: userRoles?[userId] as String?,
        ),
      ),
    );

    if (type == types.RoomType.direct.toShortString()) {
      try {
        final otherUser = users.firstWhere(
          (u) => u['id'] != firebaseUser.uid,
        );

        imageUrl = otherUser['imageUrl'] as String?;
        name = '${otherUser['firstName'] ?? ''} ${otherUser['lastName'] ?? ''}'
            .trim();
      } catch (e) {
        // Do nothing if other user is not found, because he should be found.
        // Consider falling back to some default values.
      }
    }

    data['imageUrl'] = imageUrl;
    data['name'] = name;
    data['users'] = users;

    if (data['lastMessages'] != null) {
      final lastMessages = data['lastMessages'].map((lm) {
        final author = users.firstWhere(
          (u) => u['id'] == lm['authorId'],
          orElse: () => {'id': lm['authorId'] as String},
        );

        lm['author'] = author;
        lm['createdAt'] = lm['createdAt']?.millisecondsSinceEpoch;
        lm['id'] = lm['id'] ?? '';
        lm['updatedAt'] = lm['updatedAt']?.millisecondsSinceEpoch;

        return lm;
      }).toList();

      data['lastMessages'] = lastMessages;
    }

    return types.Room.fromJson(data);
  }

  @pragma('vm:entry-point')
  static void checkPickUp(orderID) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    Database db = Database();
    Order_object order = Order_object.fromDocumentSnapshot(
        await FirebaseFirestore.instance
            .collection('Orders')
            .doc(orderID.toString())
            .get());
    if (order.get_status == OrderStatus.waitingForPickUp.toString()) {
      //change the status of the order to canceled
      db.updateOrderInfo(orderID.toString(),
          {'status': OrderStatus.canceled.toString(), 'isCancelledByProv': 0});
      //return items to daily menu
      List<DailyMenu_Item> orderItems =
          await db.retrieve_Order_Items(orderID.toString());
      db.returnItemsToDailyMenu(orderItems!, order.get_ProviderID);
      //increment the cancelation counter
      int counter = (await FirebaseFirestore.instance
              .collection('Consumers')
              .doc(order.get_consumerID)
              .get())
          .data()!['cancelCounter'];
      counter++;
      await FirebaseFirestore.instance
          .collection('Consumers')
          .doc(order.get_consumerID)
          .update({'cancelCounter': counter});
      //Notification to the consumer that his order is canceled due to no picked up
      _sendMessageCanceled(
          consEmail: order.get_consumerID,
          provName: order.getProviderName,
          orderID: orderID);
    }
  }

  static Future _sendMessageCanceled(
      {required String consEmail,
      required String provName,
      required String orderID}) async {
    String consumerToken = (await FirebaseFirestore.instance
            .collection('Consumers')
            .doc(consEmail)
            .get())
        .data()!['token'];
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": [consumerToken],
      "messageTitle": "Your order from ${provName} is canceled",
      "messageBody": 'The pick up timer expired'
    });
    print('Sent to ${consumerToken}');
    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }
}
