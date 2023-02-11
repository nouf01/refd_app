import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/ConsumerNavigation.dart';
import 'package:refd_app/Consumer_Screens/HomeScreenConsumer.dart';
import 'package:refd_app/LoginSignUp/UserType.dart';
import 'package:refd_app/LoginSignUp/EmailVerFunc.dart';

class EmailVerf extends StatefulWidget {
  const EmailVerf({super.key});

  @override
  State<EmailVerf> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EmailVerf> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return ConsumerNavigation();
          } else {
            return UserType();
          }
        }),
      ),
    );
  }
}
