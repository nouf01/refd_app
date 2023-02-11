import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/itemDetail.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/Menu.dart';
import 'package:refd_app/Provider_Screens/dMenu.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/Provider.dart';
import '../DataModel/item.dart';

class DailyMenuScreen extends StatefulWidget {
  int? choosedTab;
  DailyMenuScreen({super.key, this.choosedTab});

  @override
  State<DailyMenuScreen> createState() => _DailyMenuScreenState();
}

class _DailyMenuScreenState extends State<DailyMenuScreen> {
  Database service = Database();
  LoggedProvider log = new LoggedProvider();
  Future<List<Item>>? itemList;
  List<Item>? retrieveditemList;
  List<int> currentQuantity = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                /*leading: GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      )),*/
                title: Center(
                  child: Text('Manage Items'),
                ),
                backgroundColor: Color(0xFF66CDAA),
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child:
                            Text('Daily Menu', style: TextStyle(fontSize: 12))),
                    Tab(child: Text('Menu', style: TextStyle(fontSize: 12))),
                  ],
                )),
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xFF89CDA7),
            body: TabBarView(
              children: [
                DailyMenuWidget(),
                MenuScreen(),
              ],
            ),
          )),
    );
  }
}
