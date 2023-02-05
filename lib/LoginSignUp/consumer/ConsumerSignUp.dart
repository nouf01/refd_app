import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:refd_app/Consumer_Screens/ConsumerNavigation.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/DB_Service.dart';

import 'ConsumerLogIn.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ConsumerSignUp extends StatefulWidget {
  const ConsumerSignUp({super.key});

  @override
  State<ConsumerSignUp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ConsumerSignUp> {
  //firebase database
  Database _db = Database();
  late Consumer newConsumer;

  //text field values
  var _userName,
      _userPhoneNumber,
      _userEmail,
      _UserPassword,
      _UserConfirmpassword;

  //the key for the form
  final formKey = GlobalKey<FormState>();

  //passsword confirmation method
  bool _passwordConfirmed() {
    if (_UserPassword == _UserConfirmpassword)
      return true;
    else {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Sorry"),
              content: Text("passwords do not match"),
              actions: [
                TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });

      return false;
    }
  }

  //sign up method
  _ConsumerSignUpFunc() async {
    var formFields = formKey.currentState;
    if (formFields!.validate()) {
      if (_passwordConfirmed()) {
        formFields.save();
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _userEmail,
            password: _UserPassword,
          );
          newConsumer = Consumer(
            name: _userName,
            email: _userEmail,
            phoneNumber: _userPhoneNumber,
            uid: credential.user!.uid,
            cancelCounter: 0,
          );
          var otherUser = types.User(
            firstName: newConsumer!.get_name(),
            id: newConsumer!.get_uid(),
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/refd-d5769.appspot.com/o/User-avatar.svg.png?alt=media&token=5b494d57-6154-4fb3-a670-f454f6b77cc3',
            lastName: newConsumer!.get_name(),
          );
          await FirebaseChatCore.instance.createUserInFirestore(otherUser);
          _db.addNewConsumerToFirebase(newConsumer);
          return newConsumer;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Sorry"),
                    content: Text("Your password is too weak"),
                    actions: [
                      TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  );
                });
            print('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Sorry"),
                    content: Text("an account already exists for that email"),
                    actions: [
                      TextButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ],
                  );
                });
            print('The account already exists for that email.');
          }
        } catch (e) {
          print(e);
        }
      } else {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false, backgroundColor: Color(0xFF66CDAA)),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20, top: 50),
                child: const Text(
                  "CREATE ACCOUNT",
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
                          _userName = newValue;
                        },
                        validator: (value) {
                          if (value!.length > 30)
                            return "name can not be more than 30 letters";
                          else if (value.length < 2)
                            return "name can not be less than 2 letters";
                          else
                            return null;
                        },
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
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
                            "Name",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )),
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
                          _userPhoneNumber = newValue;
                        },
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                  .hasMatch(value))
                            return "Enter valid phone number";
                          else
                            return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Phone number",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.phone,
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
                        )),
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
                        decoration: const InputDecoration(
                          hintText: "Email",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.email,
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
                        )),
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
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 365,
                    height: 50,
                    child: TextFormField(
                        onSaved: (newValue) {
                          _UserConfirmpassword = newValue;
                        },
                        obscureText: true,
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
                            "Confirm password",
                            style: const TextStyle(
                                fontSize: 14, color: Colors.grey),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Container(
                    width: 330,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () async {
                          Consumer currentConsumer =
                              await _ConsumerSignUpFunc();
                          if (currentConsumer != null) {
                            String result = currentConsumer.get_email();

                            print(" $result ");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConsumerNavigation()),
                            );
                          } else {
                            print("SIGN UP FAILED");
                          }
                        },
                        child: const Text(
                          "Sign Up",
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
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ConsumerLogIn()),
                            );
                          },
                          child: Text(
                            "Log in",
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
