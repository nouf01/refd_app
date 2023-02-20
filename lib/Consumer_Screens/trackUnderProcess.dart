// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:refd_app/Consumer_Screens/ConsumerNavigation.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/Consumer_Screens/chat.dart';
import 'package:refd_app/Consumer_Screens/track.dart';
import 'package:refd_app/Consumer_Screens/trackCancelled.dart';
import 'package:refd_app/Consumer_Screens/trackWaiting.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/Provider_Screens/timeLineWidget.dart';
import 'package:timelines/timelines.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

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
  Stream<types.Room>? roomStream;
  Provider? prov;
  String? address = '  ';

  _initTimer() async {
    var remainingTimeFromDB =
        await db.getOrderRemainingTimer(widget.order.getorderID);
    target = DateTime.fromMillisecondsSinceEpoch(remainingTimeFromDB);
    //target = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('target'));

    if (target!.isBefore(DateTime.now())) {
      setState(() {
        timeLeft = 'Expired';
        isExpired = true;
        changeOrderStatus();
        checkConfirm(widget.order.getorderID);
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
    roomStream = getRoom(widget.order.getRoomID);
    prov = Provider.fromDocumentSnapshot(
        await db.searchForProvider(widget.order.get_ProviderID));
    Coordinates coordinates = Coordinates(prov!.get_Lat, prov!.get_Lang);
    var addressRecived =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addressRecived.first;
    address = first.addressLine.toString();

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
            ? 'Expired   '
            : target!.difference(DateTime.now()).toString();
      });
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: orderStream == null
          ? Center(
              child: SpinKitFadingCube(
                //size: 85,
                color: Color(0xFF89CDA7),
              ),
            )
          : StreamBuilder(
              stream: orderStream!,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting ||
                    snapshot.connectionState == ConnectionState.none) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Snapshot error'),
                  );
                }
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('Snapshot data missing'),
                  );
                }
                if (snapshot.hasData && !snapshot.hasError) {
                  String status = snapshot.data!.get('status');
                  String theID = snapshot.data!.get('orderID');
                  int isByProv = snapshot.data!.get('isCancelledByProv');
                  if (status == OrderStatus.canceled.toString()) {
                    //orderStream = null;
                    return trackCancelled(
                        orderID: theID, cancelByProv: isByProv);
                  } else if (status ==
                      OrderStatus.waitingForPickUp.toString()) {
                    //orderStream = null;
                    return trackWaiting(orderID: theID);
                  } else if (status == OrderStatus.pickedUp.toString()) {
                    //orderStream = null;
                    return trackWaiting(orderID: theID);
                  } else {
                    return SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const TimeLineStatus(
                            whichStatus: 0,
                          ),
                          SizedBox(height: 35),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: buildTimer())
                              ]),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              'Wait for ${widget.order.getProviderName} to accepet your order',
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 0, 0)),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 5),
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
                                        widget.order.getProviderLogo),
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
                                    title: Text(
                                        '${widget.order.getProviderName}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    subtitle: Text('${address!}'),
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
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .push(MaterialPageRoute(
                                              builder: (_) => ChatPage(
                                                room: theRoom,
                                              ),
                                            ));
                                          },
                                        );
                                      },
                                    )
                                    /*IconButton(
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
                                  ),*/
                                    )),
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
                                    /*leading: Image.network(
                                        widget.order.getProviderLogo),*/
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
                                    isThreeLine: false,
                                    title: Text(
                                      'Order #${widget.order.getorderID}',
                                    ),
                                    subtitle: Text(
                                        '${widget.order.getdate.toString().substring(0, 16)}'),
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
                            child: SizedBox(
                              height: 45,
                              width: 300,
                              child: ElevatedButton(
                                  onPressed: () async {
                                    await launchUrl(Uri.parse(
                                        'google.navigation:q=${prov!.get_Lat}, ${prov!.get_Lang}&key=AIzaSyC02VeFbURsmFAN8jKyl_OhoqE0IMPSvQM'));
                                  },
                                  child: Text(
                                    "Take me to ${widget.order.getProviderName}!",
                                    softWrap: false,
                                    selectionColor: Colors.white,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Color(0xFF89CDA7)),
                                    foregroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                  )),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          ElevatedButton(
                              style: const ButtonStyle(
                                backgroundColor:
                                    MaterialStatePropertyAll<Color>(
                                        Color.fromARGB(255, 246, 77, 65)),
                                fixedSize: MaterialStatePropertyAll<Size>(
                                    Size(150.0, 20.0)),
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
                                                      Color.fromARGB(
                                                          255, 175, 91, 76),
                                                ),
                                                onPressed: () async {
                                                  changeOrderStatus();
                                                  db.updateOrderInfo(
                                                      widget.order.getorderID,
                                                      {'isCancelledByProv': 0});
                                                  db.returnItemsToDailyMenu(
                                                      orderItems!,
                                                      widget.order
                                                          .get_ProviderID);
                                                  _sendMessage();
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            Scaffold(
                                                                backgroundColor:
                                                                    Colors
                                                                        .white,
                                                                appBar: AppBar(
                                                                  title: const Text(
                                                                      'Order Status'),
                                                                  backgroundColor:
                                                                      Color(
                                                                          0xFF89CDA7),
                                                                  leading:
                                                                      IconButton(
                                                                    icon: Icon(Icons
                                                                        .arrow_back),
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .pushAndRemoveUntil(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                ConsumerNavigation(choosedIndex: 2)),
                                                                        (Route<dynamic>
                                                                                route) =>
                                                                            false,
                                                                      );
                                                                    },
                                                                  ),
                                                                ),
                                                                body:
                                                                    trackCancelled(
                                                                  orderID: widget
                                                                      .order
                                                                      .getorderID,
                                                                  cancelByProv:
                                                                      0,
                                                                )),
                                                      ));
                                                }),
                                            ElevatedButton(
                                                child: Text("No"),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Color.fromARGB(
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
                } else {
                  return Center(
                    child: SpinKitFadingCube(
                      size: 85,
                      color: Color(0xFF89CDA7),
                    ),
                  );
                }
              }),
    );
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
          fontSize: 40, color: Color(0xFF89CDA7), fontWeight: FontWeight.bold),
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
  static void checkConfirm(orderID) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    Database db = Database();
    Order_object order = Order_object.fromDocumentSnapshot(
        await FirebaseFirestore.instance
            .collection('Orders')
            .doc(orderID.toString())
            .get());
    if (order.get_status == OrderStatus.underProcess.toString()) {
      //change the status of the order to canceled
      db.updateOrderInfo(orderID.toString(),
          {'status': OrderStatus.canceled.toString(), 'isCancelledByProv': 1});
      //return items to daily menu
      List<DailyMenu_Item> orderItems =
          await db.retrieve_Order_Items(orderID.toString());
      db.returnItemsToDailyMenu(orderItems!, order.get_ProviderID);
      //Notification to the consumer that the order is not confirmed
      _sendMessageNoResponse(
          provName: order.getProviderName,
          consEmail: order.get_consumerID,
          orderID: order.getorderID);
    }
  }

  static Future _sendMessageNoResponse(
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
      "messageBody":
          'Sorry ${provName} could not accepet your order at the moment'
    });

    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }
}
