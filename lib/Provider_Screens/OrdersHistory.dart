// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/Elements/listOfOrdersWidget.dart';

class OrdersHistoryProvider extends StatefulWidget {
  const OrdersHistoryProvider({super.key});

  @override
  State<OrdersHistoryProvider> createState() => _OrdersHistoryProviderState();
}

class _OrdersHistoryProviderState extends State<OrdersHistoryProvider> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
          length: 3,
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
                backgroundColor: Colors.green,
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
                            Text('Picked Up', style: TextStyle(fontSize: 12)))
                  ],
                )),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.green,
            body: TabBarView(
              children: [
                listOfOrders(status: 0, provID: 'Starbucks2'),
                listOfOrders(status: 1, provID: 'Starbucks2'),
                listOfOrders(status: 2, provID: 'Starbucks2'),
              ],
            ),
          )),
    );
  }
}
