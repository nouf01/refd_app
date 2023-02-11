import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:refd_app/Consumer_Screens/ConsumerNavigation.dart';
import 'package:refd_app/LoginSignUp/UserType.dart';

class EmailVerfunc extends StatefulWidget {
  const EmailVerfunc({super.key});

  @override
  State<EmailVerfunc> createState() => _EmailVerfuncState();
}

class _EmailVerfuncState extends State<EmailVerfunc> {
  bool isVerified = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isVerified = FirebaseAuth.instance.currentUser!.emailVerified;

    if (!isVerified) {
      sendVerficationEmail();
      timer =
          Timer.periodic(Duration(seconds: 3), (_) => checkEmailVerfication());
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerfication() async {
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });
    if (isVerified) {
      timer?.cancel();
    }
  }

  Future sendVerficationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) => isVerified
      ? ConsumerNavigation()
      : Scaffold(
          appBar: AppBar(
            title: Text("Email Verification"),
            backgroundColor: Color(0xFF89CDA7),
          ),
          body: Center(
            child: Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.only(top: 50),
              child: Column(
                children: [
                  Text(
                    "An email verification link was sent to your email \n \n ${FirebaseAuth.instance.currentUser!.email}",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "please verify to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xFF89CDA7),
                        fontWeight: FontWeight.bold),
                    softWrap: true,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ElevatedButton.icon(
                    onPressed: sendVerficationEmail,
                    icon: Icon(
                      color: Colors.white,
                      Icons.email,
                      size: 32,
                    ),
                    label: Text(
                      "Resend email",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        disabledBackgroundColor: Color(0xFF89CDA7),
                        backgroundColor: Color(0xFF89CDA7),
                        foregroundColor: Colors.white,
                        minimumSize: Size.fromHeight(50)),
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size.fromHeight(50)),
                    child: Text(
                      "Cancel",
                      style: TextStyle(color: Color(0xFF89CDA7), fontSize: 25),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const UserType()),
                      );
                    },
                  )
                ],
              ),
            ),
          ));
}
