import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UpdatePassword> {
  //the key for the form
  final formKey = GlobalKey<FormState>();
  var userEmail;
  TextEditingController _userEmailCont = TextEditingController();

//password update function
  void _changePassword(String currentPassword, String newPassword) async {
    formKey.currentState!.save();
    final user = await FirebaseAuth.instance.currentUser;
  }

  @override
  void dispose() {
    _userEmailCont.dispose();
    super.dispose();
  }

  //RESET password method
  Future _resetPassword() async {
    try {
      formKey.currentState!.save();
      await FirebaseAuth.instance.sendPasswordResetEmail(email: userEmail);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                content: Text(
                    "Password reset link is sent to your email, plese check your inbox"));
          });
    } on FirebaseAuthException catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(content: Text(e.message.toString()));
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF89CDA7)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10, top: 40),
              child: const Text(
                "RESET PASSWORD",
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.grey, fontSize: 30),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Form(
                key: formKey,
                child: Column(
                  children: [
                    SizedBox(
                      width: 380,
                      child: TextFormField(
                          controller: _userEmailCont,
                          onSaved: (newValue) {
                            userEmail = newValue;
                          },
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.grey,
                            ),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFF89CDA7)),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(100.0)),
                                borderSide: BorderSide(
                                    width: 3, color: Color(0xFF89CDA7))),
                            label: Text(
                              "enter your email",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    SizedBox(
                      width: 330,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            _resetPassword();
                          },
                          child: const Text(
                            "Reset",
                            selectionColor: Colors.white,
                            style: TextStyle(fontSize: 27),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Color(0xFF89CDA7)),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          )),
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
