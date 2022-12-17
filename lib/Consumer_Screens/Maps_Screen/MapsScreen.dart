import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/Cart_Screen/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/Maps_Screen/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/Orders_History_Screen/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen/Profile_Screen.dart';

import '../Home_Screen/HomeScreen.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("Maps");
  }
}
