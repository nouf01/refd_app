// ignore_for_file: prefer_const_constructors
import 'package:refd_app/Consumer_Screens/itemDetail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';
import 'LoginSignUp/UserType.dart';
import 'Provider_Screens/AddNewItemToMenu.dart';
import 'dart:isolate';
import 'Consumer_Screens/ConsumerNavigation.dart';
import 'DataModel/DB_Service.dart';
import 'DataModel/Order.dart';
import 'DataModel/item.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'messaging_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Database db = Database();

  await AndroidAlarmManager.initialize();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(MyApp());
}

/// Top level function to handle incoming messages when the app is in the background
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print(" --- background message received ---");
  print(message.notification!.title);
  print(message.notification!.body);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int choosedInde = 0;
  //bool isProvider = false;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefs;
  int? isProv;

  late FirebaseMessaging messaging;
  void initRetrival() async {
    prefs = await _prefs;
    isProv = prefs!.getInt('isProv');
    print(isProv);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initRetrival();
  }

  @override
  Widget build(BuildContext context) {
    initRetrival();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? const UserType()
          : isProv == null
              ? Container(
                  color: Colors.white,
                  child: Center(child: CircularProgressIndicator()))
              : isProv == 1
                  ? ProviderNavigation()
                  : ConsumerNavigation(),
    );
    //before seeema
    /*if (isProvider) {
      return ProviderNavigation(
        choosedIndex: choosedInde,4
      );
    } else {
      return ConsumerNavigation();
    }*/
    // return ConsumerNavigation();
  }
}
