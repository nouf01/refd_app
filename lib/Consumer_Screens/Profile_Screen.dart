import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/MapsScreen.dart';
import 'package:refd_app/Consumer_Screens/OrdersHistory_Screen.dart';
import 'package:refd_app/Consumer_Screens/Profile_Screen.dart';

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
