import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/HomeScreen.dart';
import 'package:refd_app/Consumer_Screens/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';

import 'Consumer_Screens/ConsumerNavigation.dart';
import 'DataModel/DB_Service.dart';
import 'DataModel/Order.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Database db = Database();
  //List<String> search = db.setSearchParam('Operation Flaffel ');
  //db.updateProviderInfo('operationFlaffel', {'searchCases': search});
  /*Provider p1 = Provider(
      username: 'alromansiah',
      commercialName: 'Alromansiah',
      commercialReg: '5567432587',
      email: 'alromansiah@mail.com',
      phoneNumber: '0553776223',
      accountStatus: Status.Active,
      rate: 4.4,
      tagList: [Tags.saudi],
      logoURL:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/8/81/Alromanisiah-logo.svg/195px-Alromanisiah-logo.svg.png');
  db.addNewProviderToFirebase(p1);
  //db.addToProviderTags('Lilio', [Tags.sweets, Tags.bakery, Tags.pastries]);*/
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
