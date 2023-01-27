// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
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

import '../Elements/RatingDailog.dart';
import 'ProviderNavigation.dart';

class pickedUp extends StatefulWidget {
  Order_object order;

  pickedUp({super.key, required this.order});
  @override
  _pickedUpState createState() => _pickedUpState();
}

class _pickedUpState extends State<pickedUp> {
  Database db = Database();
  List<DailyMenu_Item>? orderItems;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    orderItems = await db.retrieve_Order_Items(widget.order.getorderID);
    setState(() {});
  }

  void dispose() {
    print('********************* in Dispose');
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ProviderNavigation(choosedIndex: 0)),
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
            const TimeLineStatus(
              whichStatus: 2,
            ),
            SizedBox(height: 10),
            Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
                    height: 600,
                    child: Column(
                      children: [
                        Center(
                            child: Text('The order is picked up',
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF66CDAA)),
                                textAlign: TextAlign.center)),
                        SizedBox(height: 50),
                        Container(
                          child: ListTile(
                              //contentPadding: EdgeInsets.all(5.0),
                              leading:
                                  Image.network(widget.order.getProviderLogo),
                              isThreeLine: true,
                              onTap: () {},
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              title: Text('${widget.order.getProviderName}'),
                              subtitle: Text(
                                  'Order #${widget.order.getorderID} \n${widget.order.getdate.toString().substring(0, 16)}'),
                              trailing: IconButton(
                                iconSize: 30.0,
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.black,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(
                                          text: widget.order.getorderID))
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
                              bottom: 8.0,
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
                                        widget.order.get_total
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
                              SizedBox(height: 100)
                            ]))
                      ],
                    ))),
          ],
        ),
      );
    }
  }
}
