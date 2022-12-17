import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/Cart_Screen/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/Maps_Screen/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/Orders_History_Screen/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen/Profile_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("Home");
  }
}
