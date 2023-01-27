// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/LoginSignUp/updatePassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:refd_app/Elements/Reset.dart';
import '../../Consumer_Screens/ConsumerNavigation.dart';
import '../../DataModel/Consumer.dart';
import '../../DataModel/DB_Service.dart';
import 'ConsumerSignUp.dart';

class ConsumerLogIn extends StatefulWidget {
  const ConsumerLogIn({super.key});

  @override
  State<ConsumerLogIn> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ConsumerLogIn> {
  //by nouf
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefsAwait;
  late Future<int> isProv;

  //text fields values
  var _userEmail, _UserPassword;

  //text fields controlers
  final TextEditingController _passwordCont = new TextEditingController();
  final TextEditingController _emailCont = TextEditingController();

  //the key for the form
  final formKey = GlobalKey<FormState>();

  //firebase variables
  Database _db = Database();
  var _currentConsumer;

  void initRetrival() async {
    prefsAwait = await _prefs;
  }

  @override
  void initState() {
    initRetrival();
  }

  //sign in function
  _ConsumerSignInMang() async {
    var formFields = formKey.currentState;
    if (formFields!.validate()) {
      formFields.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _userEmail, password: _UserPassword);
        _currentConsumer = Consumer.fromDocumentSnapshot(
            await _db.searchForConsumer(_userEmail));
        if (_currentConsumer.get_cancelCounter() != null)
          return userCredential;
        else {
          return null;
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Sorry"),
                  content: Text("No user found for that email"),
                  actions: [
                    TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                );
              });
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Sorry"),
                  content: Text("Wrong password provided for that user"),
                  actions: [
                    TextButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ],
                );
              });
          print('Wrong password provided for that user.');
        }
      }
    } else
      print("invalid");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Color(0xFF66CDAA)),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, top: 150),
                child: const Text(
                  "LOG IN",
                  textAlign: TextAlign.start,
                  style: TextStyle(color: Colors.grey, fontSize: 30),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Center(
                  child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 365,
                    height: 50,
                    child: TextFormField(
                        onSaved: (newValue) {
                          _userEmail = newValue;
                        },
                        validator: ((value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value))
                            return "Enter valid email";
                          else {
                            return null;
                          }
                        }),
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF66CDAA)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF66CDAA))),
                          label: Text(
                            "Email",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 365,
                    height: 50,
                    child: TextFormField(
                        onSaved: (newValue) {
                          _UserPassword = newValue;
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
                        controller: _passwordCont,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF66CDAA)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF66CDAA))),
                          label: Text(
                            "Password",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Container(
                    width: 330,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () async {
                          var user = await _ConsumerSignInMang();
                          if (user != null) {
                            await prefsAwait!
                                .setInt('isProv', 0)
                                .then((value) => print('connnn'));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConsumerNavigation()),
                            );
                          } else
                            print("something went wrong");
                        },
                        child: const Text(
                          "Log in",
                          selectionColor: Colors.white,
                          style: TextStyle(fontSize: 27),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFF66CDAA)),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Don\'t have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConsumerSignUp()),
                            );
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(color: Color(0xFF66CDAA)),
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdatePassword()),
                            );
                          },
                          child: Text(
                            "forgot password",
                            style: TextStyle(color: Color(0xFF66CDAA)),
                          ))
                    ],
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
