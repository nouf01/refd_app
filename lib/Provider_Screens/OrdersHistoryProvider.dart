// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/Elements/listOfOrdersWidget.dart';

import '../DataModel/Provider.dart';

class OrdersHistoryProvider extends StatefulWidget {
  const OrdersHistoryProvider({super.key});

  @override
  State<OrdersHistoryProvider> createState() => _OrdersHistoryProviderState();
}

class _OrdersHistoryProviderState extends State<OrdersHistoryProvider> {
  Database db = Database();
  Provider? p;
  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    if (p == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
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
                  child: Text('Orders History'),
                ),
                backgroundColor: Color(0xFF66CDAA),
                bottom: TabBar(
                  tabs: [
                    Tab(
                        child: Text('Under process',
                            style: TextStyle(fontSize: 12))),
                    Tab(
                        child: Text('Waiting for pickup',
                            style: TextStyle(fontSize: 12))),
                    Tab(
                        child:
                            Text('Picked Up', style: TextStyle(fontSize: 12))),
                    Tab(child: Text('Canceled', style: TextStyle(fontSize: 12)))
                  ],
                )),
            resizeToAvoidBottomInset: true,
            backgroundColor: Color(0xFF66CDAA),
            body: TabBarView(
              children: [
                listOfOrders(status: 0, provID: p!.get_email),
                listOfOrders(status: 1, provID: p!.get_email),
                listOfOrders(status: 2, provID: p!.get_email),
                listOfOrders(status: 3, provID: p!.get_email)
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
