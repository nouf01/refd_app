// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/Elements/listOfOrdersWidget.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';

import '../DataModel/Provider.dart';

class OrdersHistoryProvider extends StatefulWidget {
  const OrdersHistoryProvider({super.key});

  @override
  State<OrdersHistoryProvider> createState() => _OrdersHistoryProviderState();
}

class _OrdersHistoryProviderState extends State<OrdersHistoryProvider> {
  Database db = Database();
  LoggedProvider log = LoggedProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 4,
          child: Scaffold(
            appBar: AppBar(
                /*leading: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    )),*/
                title: Center(
                  child: Text(
                    'Orders History',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                backgroundColor: Color(0xFF89CDA7),
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child: Text('Under process',
                            style: TextStyle(fontSize: 13))),
                    Tab(
                        child: Text('Waiting for pickup',
                            style: TextStyle(fontSize: 13))),
                    Tab(
                        child:
                            Text('Picked Up', style: TextStyle(fontSize: 13))),
                    Tab(child: Text('Canceled', style: TextStyle(fontSize: 13)))
                  ],
                )),
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xFF89CDA7),
            body: TabBarView(
              children: [
                listOfOrders(status: 0, provID: log.getEmailOnly()),
                listOfOrders(status: 1, provID: log.getEmailOnly()),
                listOfOrders(status: 2, provID: log.getEmailOnly()),
                listOfOrders(status: 3, provID: log.getEmailOnly())
              ],
            ),
          )),
    );
  }
}
