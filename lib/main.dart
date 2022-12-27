import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/HomeScreen.dart';
import 'package:refd_app/Consumer_Screens/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';

import 'Consumer_Screens/ConsumerNavigation.dart';
import 'DataModel/DB_Service.dart';
import 'DataModel/Order.dart';
import 'DataModel/item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Database db = Database();
  /*Provider p1 = Provider(
      logoURL:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS6_kc61Rrj_-4iv8kn01rNV2sbgcl5iwJMLhpWVs_58vSIow2zyfShGlwHUESC5j5UHYA&usqp=CAU',
      commercialName: 'Alromansiah',
      commercialReg: '234664289',
      email: 'Alromansiah@mail.com',
      phoneNumber: '0578880988',
      accountStatus: Status.Active,
      rate: 4.8,
      tagList: [Tags.saudi]);

  Item t1 = Item(
      name: 'Biryani Chicken',
      description: 'Describe Biryani Chicke',
      originalPrice: 31.0,
      providerID: p1.get_email,
      imageURL:
          'https://hungerstation.com/_next/image?url=https%3A%2F%2Fhsaa.hsobjects.com%2Fh%2Fmenuitems%2Fimages%2F007%2F543%2F165%2F956073fa55b07e7a06c6e9a45fa0deef-size1200.jpg&w=256&q=75');

  Item t2 = Item(
      name: 'Smoked Half Chicken Madhbi - Saudi Rice',
      description: 'Describe Smoked Half Chicken Madhbi - Saudi Rice ',
      originalPrice: 26.0,
      providerID: p1.get_email,
      imageURL:
          'https://hungerstation.com/_next/image?url=https%3A%2F%2Fhsaa.hsobjects.com%2Fh%2Fmenuitems%2Fimages%2F014%2F490%2F453%2F38013b9be394dbac7fa6cf008d29286b-size1200.jpg&w=256&q=75');

  Item t3 = Item(
      name: 'Margarita Medium',
      description: 'Describe Margarita Medium',
      originalPrice: 28.0,
      providerID: p1.get_email,
      imageURL:
          'https://hungerstation.com/_next/image?url=https%3A%2F%2Fhsaa.hsobjects.com%2Fh%2Fmenuitems%2Fimages%2F000%2F368%2F643%2F08bf08f69fa537a08f45d279d8fcd671-size1200.jpg&w=256&q=75');
  DailyMenu_Item d1 = DailyMenu_Item(item: t1, quantity: 6, discount: 0.50);
  DailyMenu_Item d2 = DailyMenu_Item(item: t2, quantity: 4, discount: 0.60);
  DailyMenu_Item d3 = DailyMenu_Item(item: t3, quantity: 1, discount: 0.60);
  //db.addNewProviderToFirebase(p1);
  //db.addToProviderMenu(t1);
  //db.addToProviderMenu(t2);
  //db.addToProviderMenu(t3);
  //db.addToProviderDM(d2);
  //db.addToProviderDM(d2); */
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
    if (isProvider) {
      return ProviderNavigation();
    } else {
      return ConsumerNavigation();
    }
  }
}
