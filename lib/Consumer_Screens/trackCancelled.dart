// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/ConsumerNavigation.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/Provider_Screens/timeLineWidget.dart';
import 'package:timelines/timelines.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';

class trackCancelled extends StatefulWidget {
  String orderID;
  int cancelByProv;
  trackCancelled(
      {super.key, required this.orderID, required this.cancelByProv});
  @override
  _trackCancelledState createState() => _trackCancelledState();
}

class _trackCancelledState extends State<trackCancelled> {
  Database db = Database();
  List<DailyMenu_Item>? orderItems;
  Order_object? widgetOrder;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    widgetOrder = Order_object.fromDocumentSnapshot(await FirebaseFirestore
        .instance
        .collection('Orders')
        .doc(widget.orderID)
        .get());
    orderItems = await db.retrieve_Order_Items(widget.orderID);
    setState(() {});
  }

  void dispose() {
    print('********************* in Dispose');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => ConsumerNavigation(choosedIndex: 2)),
      (Route<dynamic> route) => false,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (orderItems == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 50),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    height: 550,
                    child: Column(
                      children: [
                        Center(
                            child: widget.cancelByProv == 0
                                ? Text('The order is cancelled',
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 255, 0, 0)),
                                    textAlign: TextAlign.center)
                                : Text(
                                    'Sorry ${widgetOrder!.getProviderName} could not accepet your order at the moment',
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 0, 0, 0)),
                                    textAlign: TextAlign.center)),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          child: ListTile(
                              //contentPadding: EdgeInsets.all(5.0),
                              leading:
                                  Image.network(widgetOrder!.getProviderLogo),
                              isThreeLine: true,
                              onTap: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              title: Text('${widgetOrder!.getProviderName}'),
                              subtitle: Text(
                                  'Order #${widgetOrder!.getorderID} \n${widgetOrder!.getdate.toString().substring(0, 16)}'),
                              trailing: IconButton(
                                iconSize: 30.0,
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                          text: widgetOrder!.getorderID))
                                      .then((_) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                "Order Number copied to clipboard")));
                                  });
                                },
                              )),
                        ),
                        Divider(thickness: 2),
                        Expanded(
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 0.1),
                              itemCount: orderItems!.length,
                              padding: EdgeInsets.all(4),
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 0,
                                  child: Container(
                                    margin: EdgeInsets.all(4.0),
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            "${orderItems![index].getChoosedCartQuantity} x ${orderItems![index].getItem().get_name()} ",
                                            // maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          (orderItems![index]
                                                      .getPriceAfetr_discount *
                                                  orderItems![index]
                                                      .getChoosedCartQuantity)
                                              .toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Divider(thickness: 2),
                        Container(
                            color: Colors.white,
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              right: 16,
                              bottom: 0.0,
                              top: 4.0,
                            ),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Total: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        widgetOrder!.get_total
                                            .toStringAsFixed(2),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      Text(
                                        "Total is include VAT",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Divider(
                                height: 20,
                                thickness: 1,
                                indent: 10,
                                endIndent: 10,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                            ]))
                      ],
                    ))),
          ],
        ),
      );
    }
  }
}
