import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'DailyMenu.dart';
import 'ProvHome.dart';
import 'Menu.dart';
import 'OrdersHistory.dart';
import 'Profile.dart';

class ProviderNavigation extends StatefulWidget {
  const ProviderNavigation({super.key});

  @override
  State<ProviderNavigation> createState() => _ProviderNavigationState();
}

class _ProviderNavigationState extends State<ProviderNavigation> {
  int _pageIndex = 0;
  static const List<Widget> _Pages = [
    HomeScreenProvider(),
    MenuScreen(),
    DailyMenuScreen(),
    OrdersHistoryProvider(),
    ProfileProvider(),
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
                icon: Icon(Icons.menu_book),
                label: 'Menu',
                backgroundColor: Colors.green,
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dinner_dining),
                label: 'DailyMenu',
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
            selectedItemColor: Colors.amber[800],
            onTap: _onItemTapped,
          )),
    );
  }
}
