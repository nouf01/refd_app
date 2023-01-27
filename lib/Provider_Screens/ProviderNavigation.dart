import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/LoginSignUp/providerSign/ProviderProfile.dart';

import '../messaging_service.dart';
import 'DailyMenu.dart';
import 'ProvHome.dart';
import 'Menu.dart';
import 'OrdersHistoryProvider.dart';

class ProviderNavigation extends StatefulWidget {
  final int? choosedIndex;
  const ProviderNavigation({super.key, this.choosedIndex});

  @override
  State<ProviderNavigation> createState() => _ProviderNavigationState();
}

class _ProviderNavigationState extends State<ProviderNavigation> {
  Database db = Database();
  Provider? currentProv;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (this.widget.choosedIndex != null) {
      _pageIndex = this.widget.choosedIndex!;
      setState(() {});
    }
  }

  int _pageIndex = 0;
  List<Widget> _Pages = [
    HomeScreenProvider(),
    MenuScreen(),
    DailyMenuScreen(),
    OrdersHistoryProvider(),
    ProviderProfile(),
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
                backgroundColor: Color(0xFF66CDAA),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.menu_book),
                label: 'Menu',
                backgroundColor: Color(0xFF66CDAA),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.dinner_dining),
                label: 'DailyMenu',
                backgroundColor: Color(0xFF66CDAA),
              ),
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
          )),
    );
  }
}
