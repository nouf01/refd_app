import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/Cart_Screen/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/Maps_Screen/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/Orders_History_Screen/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen/Profile_Screen.dart';

import '../Home_Screen/HomeScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Text("Profile");
  }
}
