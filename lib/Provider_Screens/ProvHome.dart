// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/Elements/listOfOrdersWidget.dart';
import 'package:refd_app/Elements/restaurantInfo.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../DataModel/Provider.dart';

class HomeScreenProvider extends StatefulWidget {
  const HomeScreenProvider({super.key});

  @override
  State<HomeScreenProvider> createState() => _HomeScreenProviderState();
}

class _HomeScreenProviderState extends State<HomeScreenProvider> {
  Database db = Database();
  Provider? p;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
                leading: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Image.network(p!.get_logoURL),
                ),
                title: Center(
                  child: Text(p!.get_commercialName),
                ),
                backgroundColor: Colors.green,
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child: Text('Under process',
                            style: TextStyle(fontSize: 12))),
                    Tab(
                        child: Text('Waiting for pickup',
                            style: TextStyle(fontSize: 12))),
                  ],
                )),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.green,
            body: TabBarView(
              children: [
                listOfOrders(status: 0, provID: p!.get_email),
                listOfOrders(status: 1, provID: p!.get_email),
              ],
            ),
          )),
    );
  }

  Future<void> _initRetrieval() async {
    p = Provider.fromDocumentSnapshot(
        await db.searchForProvider('MunchBakery@mail.com'));
    setState(() {});
    print('mmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm');
  }
}
