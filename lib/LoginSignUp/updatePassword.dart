import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:refd_app/DataModel/DB_Service.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<UpdatePassword> {
  //firebase database & current user objects
  Database db = Database();
  dynamic user;
  var currentConsumer;

  //the key for the form
  final formKey = GlobalKey<FormState>();

  //passwords
  var oldPass, newPass;

  //save fields
  bool _saveFields() {
    var formFields = formKey.currentState;
    if (formFields!.validate()) {
      formFields.save();
      return true;
    } else
      return false;
  }

//password update function
  void _changePassword(String currentPassword, String newPassword) async {
    final user = await FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    user.reauthenticateWithCredential(cred).then((value) {
      user.updatePassword(newPassword).then((_) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Updated!"),
                content: Text("your password has been successfully updated"),
                actions: [
                  TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              );
            });
      }).catchError((error) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Error!"),
                content: Text("the password you entred was not correct"),
                actions: [
                  TextButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                ],
              );
            });
      });
    }).catchError((err) {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 170,
            ),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(left: 20, top: 50),
              child: const Text(
                "UPDATE PASSWORD",
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
                    TextFormField(
                        onSaved: (newValue) {
                          oldPass = newValue;
                        },
                        validator: (value) {
                          if (value!.length > 50)
                            return "password can not be more than 50 letters";
                          else if (value.length < 6)
                            return "password is too short";
                          else
                            return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF66CDAA)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF66CDAA))),
                          label: Text(
                            "Old password",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                        onSaved: (newValue) {
                          newPass = newValue;
                        },
                        validator: (value) {
                          if (value!.length > 50)
                            return "password can not be more than 50 letters";
                          else if (value.length < 6)
                            return "password is too short";
                          else
                            return null;
                        },
                        obscureText: true,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF66CDAA)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF66CDAA))),
                          label: Text(
                            "New password",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )),
                    const SizedBox(
                      height: 40,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          var formFields = formKey.currentState;
                          if (formFields!.validate()) {
                            formFields.save();
                            _changePassword(oldPass, newPass);
                          }
                        },
                        child: const Text(
                          "Update",
                          selectionColor: Colors.white,
                          style: TextStyle(fontSize: 27),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF66CDAA)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        )),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
