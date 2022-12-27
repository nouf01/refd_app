import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
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
