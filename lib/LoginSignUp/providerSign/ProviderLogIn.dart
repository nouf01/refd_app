import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/Elements/Reset.dart';
import 'package:refd_app/LoginSignUp/providerSign/providerSetLoc.dart';
import 'package:refd_app/LoginSignUp/updatePassword.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../DataModel/DB_Service.dart';
import '../../DataModel/Provider.dart';
import '../../Provider_Screens/ProviderNavigation.dart';
import 'ProviderSignUp.dart';

class ProviderLogIn extends StatefulWidget {
  const ProviderLogIn({super.key});

  @override
  State<ProviderLogIn> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProviderLogIn> {
  //by nouf
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences? prefsAwait;
  late Future<int> isProv;

  //text fields values
  var userEmail, UserPassword;
  //the key for the form
  final formKey = GlobalKey<FormState>();

  //text fields controlers
  final TextEditingController passwordCont = TextEditingController();
  final TextEditingController emailCont = TextEditingController();

  //firebase variables
  Database db = Database();
  var currentProvider;

  void initRetrival() async {
    prefsAwait = await _prefs;
  }

  @override
  void initState() {
    initRetrival();
  }

  //sign in function
  ProviderSignInMang() async {
    var formFields = formKey.currentState;
    if (formFields!.validate()) {
      formFields.save();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: userEmail, password: UserPassword);
        currentProvider = Provider.fromDocumentSnapshot(
            await db.searchForProvider("$userEmail"));
        if (currentProvider.get_commercialReg != null)
          return userCredential;
        else
          return null;
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
      appBar: AppBar(backgroundColor: Color(0xFF89CDA7)),
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
                          userEmail = newValue;
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
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF89CDA7)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF89CDA7))),
                          label: Text(
                            "Email",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                          UserPassword = newValue;
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
                        controller: passwordCont,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.grey,
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF89CDA7)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF89CDA7))),
                          label: Text(
                            "Password",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
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
                          var user = await ProviderSignInMang();
                          if (user != null) {
                            await prefsAwait!
                                .setInt('isProv', 1)
                                .then((value) => print('donnnnnnne'));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProviderNavigation()),
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
                              MaterialStateProperty.all(Color(0xFF89CDA7)),
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
                      const Text(
                        "Don\'t have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => providerSetLoc()),
                            );
                          },
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(color: Color(0xFF89CDA7)),
                          ))
                    ],
                  ),
                  const SizedBox(
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
                          child: const Text(
                            "forgot password",
                            style: TextStyle(color: Color(0xFF89CDA7)),
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
