// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/theme/colors.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/json/day_month.dart';

import 'package:refd_app/Provider_Screens/stat/statLib/json/budget_json.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons_null_safety/flutter_icons_null_safety.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:refd_app/Provider_Screens/stat/statLib/widget/chart.dart';

class StatsPage extends StatefulWidget {
  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  int activeDay = 3;
  LoggedProvider log = LoggedProvider();
  Database db = Database();
  Provider? p;
  Item? mostItem;
  Item? lowestItem;
  List numbers = [];
  List items = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  bool showAvg = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: grey.withOpacity(0.05),
      body: getBody(),
    );
  }

  Widget getBody() {
    var size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: white, boxShadow: [
              BoxShadow(
                color: grey.withOpacity(0.01),
                spreadRadius: 10,
                blurRadius: 3,
                // changes position of shadow
              ),
            ]),
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 60, right: 20, left: 20, bottom: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      Text(
                        "Stats",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: black),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
              spacing: 20,
              children: List.generate(numbers.length, (index) {
                return Container(
                  width: (size.width - 60) / 2,
                  height: 170,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: numbers[index]['color']),
                          child: Center(
                              child: Icon(
                            numbers[index]['icon'],
                            color: white,
                          )),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              numbers[index]['label'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              numbers[index]['cost'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              })),
          SizedBox(height: 10),
          Wrap(
              spacing: 20,
              children: List.generate(items.length, (index) {
                return Container(
                  width: (size.width - 60) / 2,
                  height: 200,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: grey.withOpacity(0.01),
                          spreadRadius: 10,
                          blurRadius: 3,
                          // changes position of shadow
                        ),
                      ]),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 25, right: 25, top: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          items[index]['label'],
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: Color(0xff67727d)),
                        ),
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: numbers[index]['color']),
                          child: Center(
                            child: Image.network(
                              items[index]['image'],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index]['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
                                  color: Color(0xff67727d)),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              items[index]['cost'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: items[index]['color']),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              }))
        ],
      ),
    );
  }

  Future<void> _initRetrieval() async {
    p = await log.buildProvider();
    numbers = [
      {
        "icon": Icons.money,
        "color": green,
        "label": "Total Sales",
        "cost": p!.totalSales.toStringAsFixed(2) + " SAR",
      },
      {
        "icon": Ionicons.md_restaurant,
        "color": yellow,
        "label": "Total Saved Meals",
        "cost": p!.totalMeals.toString(),
      }
    ];
    setState(() {});
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Providers")
        .doc(p!.get_email)
        .collection('itemsList')
        .orderBy('howManyPickedUp')
        .get();
    List<Item> sorted = snapshot.docs
        .map((docSnapshot) => Item.fromDocumentSnapshot(docSnapshot))
        .toList();
    mostItem = sorted[sorted.length - 1];
    lowestItem = sorted[0];
    items = [
      {
        "image": mostItem!.get_imageURL(),
        "color": green,
        "label": "Most Picked Up Item",
        "cost": mostItem!.get_HowManyPicked().toString() + ' Pick Ups',
        'name': mostItem!.get_name(),
      },
      {
        "image": lowestItem!.get_imageURL(),
        "color": red,
        "label": "Lowest Picked Up Item",
        "cost": lowestItem!.get_HowManyPicked().toString() + ' Pick Ups',
        'name': lowestItem!.get_name(),
      }
    ];
    setState(() {});
  }

  Future<Item> getMostLowest(int isLowest) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Providers")
        .doc(p!.get_email)
        .collection('itemsList')
        .orderBy('howManyPickedUp')
        .get();
    List<Item> sorted = snapshot.docs
        .map((docSnapshot) => Item.fromDocumentSnapshot(docSnapshot))
        .toList();
    if (isLowest == 1) {
      return sorted[sorted.length - 1];
    } else {
      return sorted[1];
    }
  }
}
