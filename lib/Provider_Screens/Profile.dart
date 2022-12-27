import 'package:flutter/material.dart';

class ProfileProvider extends StatefulWidget {
  const ProfileProvider({super.key});

  @override
  State<ProfileProvider> createState() => _ProfileProviderState();
}

class _ProfileProviderState extends State<ProfileProvider> {
  @override
  Widget build(BuildContext context) {
    return Text("Profile");
  }
}
