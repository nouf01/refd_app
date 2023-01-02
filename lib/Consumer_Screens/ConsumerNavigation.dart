import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/HomeScreenConsumer.dart';
import 'package:refd_app/Consumer_Screens/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen.dart';
import 'package:refd_app/DataModel/Provider.dart';

import '../DataModel/DB_Service.dart';
import '../DataModel/DailyMenu_Item.dart';

class ConsumerNavigation extends StatefulWidget {
  const ConsumerNavigation({super.key});

  @override
  State<ConsumerNavigation> createState() => _ConsumerNavigationState();
}

class _ConsumerNavigationState extends State<ConsumerNavigation> {
  int _pageIndex = 0;
  static const List<Widget> _Pages = [
    HomeScreen(),
    MapsScreen(),
    CartScreen(),
    OrdersHistoryScreen(),
    ProfileScreen(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _pageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: _Pages.elementAt(_pageIndex),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map),
                label: 'Maps',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_bag),
                label: 'Cart',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history),
                label: 'Orders History',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profile',
                backgroundColor: Colors.green,
              ),
            ],
            currentIndex: _pageIndex,
            selectedItemColor: Colors.black,
            onTap: _onItemTapped,
          )),
    );
  }
}
