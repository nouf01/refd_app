import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen.dart';

import 'HomeScreen.dart';

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
