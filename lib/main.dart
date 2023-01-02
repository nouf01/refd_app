import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';
import 'Provider_Screens/AddNewItemToMenu.dart';

import 'Consumer_Screens/ConsumerNavigation.dart';
import 'DataModel/DB_Service.dart';
import 'DataModel/Order.dart';
import 'DataModel/item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Database db = Database();
  /*Consumer c1 = Consumer.fromDocumentSnapshot(
      await db.searchForConsumer('emailprint@gmail.com'));
  print(c1.get_email());
  print('***********************************');
  print(c1.get_name());*/

  // get DM items from the provider it self
  /*List<DailyMenu_Item> dList =
      await db.retrieve_DMmenu_Items('Alromansiah@mail.com');

  Order_object o1 = Order_object(
      date: DateTime.now(),
      total: dList[0].getPriceAfetr_discount + dList[1].getPriceAfetr_discount,
      providerID: 'Alromansiah@mail.com',
      consumerID: 'nouf888s@gmail.com',
      status: OrderStatus.underProcess);

  await db.addNewOrderToFirebase(o1);
  db.addItemsToOrder(o1, [dList[0], dList[1]]);*/
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isProvider = false;

  @override
  Widget build(BuildContext context) {
   /* if (isProvider) {
      return ProviderNavigation();
    } else {
      return ConsumerNavigation();
    }*/

    return ProviderNavigation();


  }
}
