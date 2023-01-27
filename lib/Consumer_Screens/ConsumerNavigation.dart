import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/HomeScreenConsumer.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistoryConsumer.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/LoginSignUp/consumer/ConsumerMap.dart';
import 'package:refd_app/LoginSignUp/consumer/ConsumerProfile.dart';

import '../DataModel/Consumer.dart';
import '../messaging_service.dart';

class ConsumerNavigation extends StatefulWidget {
  final int? choosedIndex;
  const ConsumerNavigation({super.key, this.choosedIndex});

  @override
  State<ConsumerNavigation> createState() => _ConsumerNavigationState();
}

class _ConsumerNavigationState extends State<ConsumerNavigation> {
  int _pageIndex = 0;
  Database db = Database();

  static List<Widget> _Pages = [
    HomeScreen(),
    ConsumerMap(),
    OrdersHistoryScreen(),
    ConsumerProfile(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.choosedIndex != null) {
      _pageIndex = this.widget.choosedIndex!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: _Pages.elementAt(_pageIndex),
      bottomNavigationBar: BottomNavigationBar(
          iconSize: 30,
          unselectedFontSize: 10,
          selectedFontSize: 10,
          currentIndex: _pageIndex,
          onTap: _onItemTapped,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: "home",
                backgroundColor: Color(0xFF66CDAA)),
            BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: "map",
                backgroundColor: Color(0xFF66CDAA)),
            BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: "order history",
                backgroundColor: Color(0xFF66CDAA)),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "profile",
                backgroundColor: Color(0xFF66CDAA)),
          ]),
    )
        /*BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Color(0xFF66CDAA),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Maps',
                backgroundColor: Color(0xFF66CDAA),
              ),
              /*BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart),
                label: 'Cart',
                backgroundColor: Color(0xFF66CDAA),
              ),*/
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Orders History',
                backgroundColor: Color(0xFF66CDAA),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Color(0xFF66CDAA),
              ),
            ],
            currentIndex: _pageIndex,
            selectedItemColor: Colors.black,
            onTap: _onItemTapped,
          )),*/
        );
  }
}
