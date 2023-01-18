// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:refd_app/Provider_Screens/timeLineWidget.dart';
import 'package:timelines/timelines.dart';
import 'JustSave.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:firebase_database/firebase_database.dart';

class Order_Status extends StatefulWidget {
  Order_object order;
  Order_Status({super.key, required this.order});
  @override
  _Order_StatusState createState() => _Order_StatusState();
}

class _Order_StatusState extends State<Order_Status> {
  Timer? timer;

  DateTime? target;
  String timeLeft = "";
  bool running = true;
  Database db = Database();
  bool isExpired = false;

  /*void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer!.cancel();
        }
      });
    });
  }*/

  _initTimer() async {
    //prefs = await SharedPreferences.getInstance();

    var remainingTimeFromDB =
        await db.getOrderRemainingTimer(widget.order.getorderID);
    target = DateTime.fromMillisecondsSinceEpoch(remainingTimeFromDB);
    //target = DateTime.fromMillisecondsSinceEpoch(prefs.getInt('target'));

    if (remainingTimeFromDB == -1 /*|| target!.isBefore(DateTime.now())*/) {
      print('Hi');
      target = DateTime.now().add(Duration(minutes: 5));
      db.setOrderTimer(widget.order.getorderID, target!.millisecondsSinceEpoch);
      executeTimer();
    } else if (target!.isBefore(DateTime.now())) {
      print(
          'Yaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaay');
      setState(() {
        timeLeft = '5 min expired';
        isExpired = true;
      });
      print(timeLeft);
    } else {
      executeTimer();
    }
  }

  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  void dispose() {
    print('********************* in Dispose');
    db.setOrderTimer(widget.order.getorderID, target!.millisecondsSinceEpoch);
    //prefs.setInt('target', target.millisecondsSinceEpoch);
    running = false;
    super.dispose();
  }

  void executeTimer() async {
    while (running) {
      setState(() {
        timeLeft = DateTime.now().isAfter(target!)
            ? '5 min expired'
            : target!.difference(DateTime.now()).toString();
      });
      await Future.delayed(Duration(seconds: 1), () {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Status'),
        backgroundColor: Color(0xFF66CDAA),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            //const TimeLineStatus(),
            const SizedBox(height: 10),
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(padding: const EdgeInsets.all(37.0), child: buildTimer()),
            ]),
            const SizedBox(height: 30),
            ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Color(0xFF66CDAA)),
                  fixedSize: MaterialStatePropertyAll<Size>(Size(200.0, 20.0)),
                ),
                onPressed: () {
                  changeOrderStatus();
                },
                child: const Text(
                  'Button',
                  style: TextStyle(fontSize: 18),
                )),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_forward),
        onPressed: () {
          setState(() {
            _processIndex = (_processIndex + 1) % _processes.length;
          });
        },
        backgroundColor: inProgressColor,
      ),*/
    );
  }

  changeOrderStatus() {
    Database db = Database();
    db.updateOrderInfo(widget.order.getorderID, {
      'status':
          OrderStatus.waitingForPickUp.toString().replaceAll('OrderStatus.', '')
    });
  }

  Widget buildTimer() {
    return SizedBox(
      height: 200,
      width: 320,
      child: Stack(
        fit: StackFit.expand,
        children: [
          /*CircularProgressIndicator(
            value: target!.difference(DateTime.now()).inMilliseconds.toDouble(),
            strokeWidth: 10,
            valueColor: AlwaysStoppedAnimation(Color(0xFF66CDAA)),
            backgroundColor: Colors.grey,
          )*/
          Center(
              child: Text(
            '${timeLeft}',
            style: const TextStyle(
                fontSize: 40,
                color: Color(0xFF66CDAA),
                fontWeight: FontWeight.bold),
          ))
        ],
      ),
    );
  }
}
