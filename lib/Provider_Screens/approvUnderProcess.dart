// ignore_for_file: prefer_const_constructors
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/ConsumerNavigation.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/Consumer_Screens/track.dart';
import 'package:refd_app/Consumer_Screens/trackCancelled.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';
import 'package:refd_app/Provider_Screens/timeLineWidget.dart';
import 'package:refd_app/Provider_Screens/waitingForPick.dart';
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

import 'ProvHome.dart';
import 'canceled.dart';
import 'chat.dart';

class approveUnderProcess extends StatefulWidget {
  Order_object order;
  approveUnderProcess({super.key, required this.order});
  @override
  _approveUnderProcessState createState() => _approveUnderProcessState();
}

class _approveUnderProcessState extends State<approveUnderProcess> {
  LoggedProvider log = LoggedProvider();
  Timer? timer;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? orderStream;
  DateTime? target;
  String timeLeft = "expired";
  bool running = true;
  Database db = Database();
  bool isExpired = false;
  List<DailyMenu_Item>? orderItems;
  Consumer? consumer;
  Stream<types.Room>? roomStream;

  /*void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer!.cancel();
        }
      });
    });
  }*/

  _initTimer() async {
    //prefs = await SharedPreferences.getInstance();

    var remainingTimeFromDB =
        await db.getOrderRemainingTimer(widget.order.getorderID);
    target = DateTime.fromMillisecondsSinceEpoch(remainingTimeFromDB);
    //target = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('target'));

    if (target!.isBefore(DateTime.now())) {
      print(
          'Yaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaay');
      setState(() {
        timeLeft = 'expired';
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
            ? 'expired   '
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
            return Canceled(order: widget.order, cancelByProv: isByProv);
          } else if (status == OrderStatus.waitingForPickUp.toString()) {
            orderStream = null;
            return WaitingForPickUp(order: widget.order);
          } else {
            if (consumer == null) {
              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const TimeLineStatus(
                    whichStatus: 0,
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
                      'Approve the order within 5 minutes\n if the timer expired the order will be canceled',
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
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color: Colors.black),
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
                            subtitle: Text('${consumer!.get_email()}'),
                            trailing: StreamBuilder<types.Room>(
                              stream: roomStream,
                              builder: (context, snapshot) {
                                return IconButton(
                                  iconSize: 30.0,
                                  icon: Icon(
                                    Icons.chat,
                                    color: Color(0xFF66CDAA),
                                  ),
                                  onPressed: () async {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ChatPage(
                                          room: snapshot.data!,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ))),
                  ),
                  ElevatedButton(
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Color(0xFF66CDAA)),
                        fixedSize:
                            MaterialStatePropertyAll<Size>(Size(200.0, 20.0)),
                      ),
                      onPressed: () async {
                        //change order status to waiting for pick up
                        changeOrderStatus();
                        //start the 45 min waiting for pick up timer
                        var target = DateTime.now().add(Duration(minutes: 45));
                        db.setOrderTimer(widget.order.getorderID,
                            target!.millisecondsSinceEpoch);
                        //start timer in the background
                        await AndroidAlarmManager.oneShotAt(
                          DateTime.fromMillisecondsSinceEpoch(
                              target!.millisecondsSinceEpoch),
                          int.parse(widget.order.getorderID),
                          checkPickUp,
                          wakeup: true,
                        );
                        //change the page to waiting for pick up page
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "Order is confirmed",
                              ),
                              content: const Text(
                                "We will notify the consumer to pick up the order within 45 minutes",
                              ),
                              actions: [
                                ElevatedButton(
                                  child: Text("OK"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF66CDAA),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Scaffold(
                                              backgroundColor: Colors.white,
                                              appBar: AppBar(
                                                title:
                                                    const Text('Order Status'),
                                                backgroundColor: Color.fromARGB(
                                                    255, 88, 207, 108),
                                                leading: IconButton(
                                                  icon: Icon(Icons.arrow_back),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ProviderNavigation(
                                                                  choosedIndex:
                                                                      0)),
                                                    );
                                                  },
                                                ),
                                              ),
                                              body: WaitingForPickUp(
                                                order: widget.order,
                                              ))),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                        //Notification to the user that his order is confirmed
                        _sendMessageReady(
                            consEmail: consumer!.get_email(),
                            provName: widget.order.getProviderName,
                            orderID: widget.order.getorderID);
                        //if the timer expired change to cancel and notify the user
                      },
                      child: const Text(
                        'Approve Order',
                        style: TextStyle(fontSize: 18),
                      )),
                ],
              ),
            );
          }
        });
  }

  static Future _sendMessageReady(
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
      "messageTitle": "Your order from ${provName} is ready for pick up",
      "messageBody": 'You have 45 min to pick up your order!'
    });

    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
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

    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }

  changeOrderStatus() {
    Database db = Database();
    db.updateOrderInfo(widget.order.getorderID,
        {'status': OrderStatus.waitingForPickUp.toString()});
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
          provName: order.get_consumerID,
          orderID: orderID);
    }
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
}
