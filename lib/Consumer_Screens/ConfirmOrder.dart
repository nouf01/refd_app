// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/HomeScreenConsumer.dart';
import 'package:refd_app/Consumer_Screens/LoggedConsumer.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/Consumer_Screens/trackCancelled.dart';
import 'package:refd_app/Consumer_Screens/trackUnderProcess.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/Provider_Screens/ManageOrders.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/DailyMenu_Item.dart';
import '../Elements/restaurantInfo.dart';
import 'ConsumerNavigation.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ConfirmOrder extends StatefulWidget {
  //>>>>>>>>>>> Here must be the concumerCart
  const ConfirmOrder({super.key});
  @override
  State<ConfirmOrder> createState() => _ConfirmOrderState();
}

class _ConfirmOrderState extends State<ConfirmOrder> {
  Database DB = Database();
  LoggedConsumer log = LoggedConsumer();
  Provider? prov;
  Consumer? currentUser;
  List<DailyMenu_Item>? cart;
  double? total;
  String? orderID;

  Future<void> _initRetrieval() async {
    currentUser = await log.buildConsumer();
    total = currentUser!.cartTotal;
    cart = await DB.retrieve_Cart_Items(currentUser!.get_email());
    prov = Provider.fromDocumentSnapshot(
        await DB.searchForProvider(cart![0].getItem().get_providerID));
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    if (prov == null) {
      return Container(
          color: Colors.white,
          child: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF66CDAA),
        ),
        body: Column(children: [
          SafeArea(
            child: Column(
              children: [
                restaurantInfo(
                  currentProve: prov!,
                ),
                Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: ListView.separated(
                      separatorBuilder: (context, index) => const SizedBox(
                        height: 0.1,
                      ),
                      shrinkWrap: true,
                      itemCount: cart!.length,
                      padding: EdgeInsets.all(4),
                      itemBuilder: (context, index) => Card(
                        elevation: 0,
                        child: Container(
                          margin: EdgeInsets.all(4.0),
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Text(
                                  "${cart![index].getChoosedCartQuantity} x ${cart![index].getItem().get_name()} ",
                                  // maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              Text(
                                (cart![index].getPriceAfetr_discount *
                                        cart![index].getChoosedCartQuantity)
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w900,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16,
                      bottom: 8.0,
                      top: 4.0,
                    ),
                    child: Column(
                      children: [
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
                                  total!.toStringAsFixed(2),
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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Payment method is pay onsite,",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13.0,
                              ),
                            ),
                            Text(
                              "You can cancel your order only if it's still under processing ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                            Text(
                              "Note: If you do not pickup your order for a certain number of times, you will not be able to use the application again!",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Align(
                                alignment: Alignment.center,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16.0,
                                    ),
                                    primary: Color(0xFF66CDAA),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    //new order object
                                    Order_object newOrder = Order_object(
                                      date: DateTime.now(),
                                      total: total,
                                      providerID: prov!.get_email,
                                      consumerID: currentUser!.get_email(),
                                      status: OrderStatus.underProcess,
                                      providerLogo: prov!.get_logoURL,
                                      providerName: prov!.get_commercialName,
                                      remainingTimer: DateTime.now()
                                          .add(Duration(minutes: 5))
                                          .millisecondsSinceEpoch,
                                    );
                                    //create room for chatting
                                    var doc = await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(prov!.get_uid())
                                        .get();
                                    var otherUser = types.User(
                                      firstName: doc.data()!['commercialName'],
                                      id: prov!.get_uid(),
                                      imageUrl:
                                          'https://firebasestorage.googleapis.com/v0/b/refd-d5769.appspot.com/o/User-avatar.svg.png?alt=media&token=5b494d57-6154-4fb3-a670-f454f6b77cc3',
                                      lastName: doc.data()!['commercialName'],
                                    );
                                    var room = await FirebaseChatCore.instance
                                        .createRoom(otherUser);
                                    newOrder.setRoomID(room.id);
                                    //add the object to firebase
                                    DB.addNewOrderToFirebase(newOrder);
                                    //add items list to the order
                                    DB.addItemsToOrder(newOrder, cart!);
                                    //intilized the 5 minute time write the deadline in firebase
                                    var target = DateTime.now()
                                        .add(Duration(minutes: 5));
                                    DB.setOrderTimer(newOrder.getorderID,
                                        target!.millisecondsSinceEpoch);
                                    //intilize a timer in the background
                                    await AndroidAlarmManager.oneShotAt(
                                      DateTime.fromMillisecondsSinceEpoch(
                                          target!.millisecondsSinceEpoch),
                                      int.parse(newOrder.getorderID),
                                      checkConfirm,
                                      wakeup: true,
                                    );
                                    //empty the cart
                                    DB.emptyTheCart(currentUser!.get_email());
                                    //notification to the provider
                                    _sendMessage(
                                        consEmail: currentUser!.get_email(),
                                        provEmail: prov!.get_email,
                                        orderID: newOrder.getorderID);
                                    //show dialog
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                            "your order placed sucessfully!",
                                          ),
                                          content: const Text(
                                            " you can track it in the order history screen",
                                          ),
                                          actions: [
                                            ElevatedButton(
                                              child: Text("OK"),
                                              style: ElevatedButton.styleFrom(
                                                  primary: Color(0xFF66CDAA)),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Scaffold(
                                                              backgroundColor:
                                                                  Colors.white,
                                                              appBar: AppBar(
                                                                title: const Text(
                                                                    'Order Status'),
                                                                backgroundColor:
                                                                    Color(
                                                                        0xFF66CDAA),
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
                                                              body: trackUnderProcess(
                                                                  order:
                                                                      newOrder,
                                                                  provider:
                                                                      prov ////////////////////////////////////////////////////////////////////////
                                                                  )),
                                                    ));
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text("Confirm my order"),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]));
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
      _sendMessageCanceled(
          providerName: order.getProviderName, userEmail: order.get_consumerID);
    }
  }

  static Future _sendMessage(
      {required String provEmail,
      required String consEmail,
      required String orderID}) async {
    String providerToken = (await FirebaseFirestore.instance
            .collection('Providers')
            .doc(provEmail)
            .get())
        .data()!['token'];
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": [providerToken],
      "messageTitle": "New order #{$orderID}",
      "messageBody": 'New order need to be confirmed within 5 minutes'
    });

    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }

  static Future _sendMessageCanceled(
      {required String userEmail, required String providerName}) async {
    String consumerToken = (await FirebaseFirestore.instance
            .collection('Consumers')
            .doc(userEmail)
            .get())
        .data()!['token'];
    var func = FirebaseFunctions.instance.httpsCallable("notifySubscribers");
    var res = await func.call(<String, dynamic>{
      "targetDevices": [consumerToken],
      "messageTitle": "Your order from ${providerName} is canceled",
      "messageBody":
          'Sorry ${providerName} could not respond to your order at the moment'
    });
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
