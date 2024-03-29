import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../DataModel/Consumer.dart';
import '../../DataModel/DB_Service.dart';
import '../UserType.dart';
import '../updatePassword.dart';

class ConsumerProfile extends StatefulWidget {
  @override
  State<ConsumerProfile> createState() => _MyConsumerProfileState();
}

class _MyConsumerProfileState extends State<ConsumerProfile> {
  //the key for the form
  final formKey = GlobalKey<FormState>();

  //firebase variables
  Database _db = Database();
  var _currentConsumer;
  var _currentUser;

  //user info
  var _userEmail, _consname, _consphoneNumber;

//get the user that is logged in
  _getCurrentUserInfo() {
    final _auth = FirebaseAuth.instance.currentUser;
    _userEmail = _auth!.email!.toString();
    return _auth;
  }

//get current consumer info (email, name, phone number)
  Future _setCurrentUserInfo() async {
    _currentUser = _getCurrentUserInfo();
    _currentUser = FirebaseAuth.instance.currentUser;
    _userEmail = _currentUser!.email!.toString();
    if (_currentUser != null) {
      Database db = Database();
      _currentConsumer =
          Consumer.fromDocumentSnapshot(await db.searchForConsumer(_userEmail));
      _consname = _currentConsumer.get_name();
      _consphoneNumber = _currentConsumer.get_phoneNumber();
    }
  }

  //update user info
  _UpdateConsumerInfo() {
    var formFields = formKey.currentState;
    if (formFields!.validate()) {
      formFields.save();
      _db.updateConsumerInfo(_userEmail, {
        'name': _consname,
        'email': _userEmail,
        'phoneNumber': _consphoneNumber
      });
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Saved!"),
              content: Text("your information has been successfully updated"),
              actions: [
                TextButton(
                    child: Text('Ok'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
              ],
            );
          });
      setState(() {});
    }
  }

  //initial state
  @override
  void initState() {
    super.initState();
    _setCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _db.searchForConsumer(_userEmail),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 65,
              backgroundColor: Color(0xFF89CDA7),
              centerTitle: true,
              title: const Text(
                "Account details",
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
              leading: Icon(Icons.account_circle_rounded),
              actions: [
                TextButton(
                    onPressed: () => _UpdateConsumerInfo(),
                    child: Text(
                      "save",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                //fields to be displayed
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    width: 350,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome, $_consname",
                          style: TextStyle(fontSize: 27),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "$_userEmail",
                          style:
                              TextStyle(fontSize: 20, color: Color(0xFF89CDA7)),
                          textAlign: TextAlign.left,
                        )
                      ],
                    ),
                  ),
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          //name field
                          SizedBox(height: 30),
                          SizedBox(
                            width: 355,
                            height: 45,
                            child: TextFormField(
                              onSaved: (newValue) {
                                _consname = newValue;
                              },
                              validator: (value) {
                                if (value!.length > 30)
                                  return "name can not be more than 30 letters";
                                else if (value.length < 2)
                                  return "name can not be less than 2 letters";
                                else
                                  return null;
                              },
                              initialValue: _consname,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(fontSize: 17),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xFF89CDA7),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(100))),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),

                          SizedBox(
                            width: 355,
                            height: 45,
                            child: TextFormField(
                              onSaved: (newValue) {
                                _consphoneNumber = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                        .hasMatch(value))
                                  return "Enter valid phone number";
                                else
                                  return null;
                              },
                              initialValue: _consphoneNumber,
                              decoration: InputDecoration(
                                  labelText: "Phone number",
                                  labelStyle: TextStyle(fontSize: 17),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Color(0xFF89CDA7),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(100))),
                            ),
                          )
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    width: 330,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UpdatePassword()),
                          );
                        },
                        child: const Text(
                          "Update password",
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
                  SizedBox(
                    height: 115,
                  ),
                  Text(
                    "Technical Support",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "RefdSupport@mail.com",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Text(
                    "0112849234",
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  //logout button
                  Center(
                    child: Container(
                      width: 330,
                      height: 45,
                      child: ElevatedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UserType()),
                            );
                          },
                          child: const Text(
                            "Log out",
                            selectionColor: Colors.white,
                            style: TextStyle(fontSize: 27),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.grey),
                            foregroundColor:
                                MaterialStateProperty.all(Colors.white),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: SpinKitFadingCube(
              size: 85,
              color: Color(0xFF89CDA7),
            ),
          );
        else
          return Text("error", style: TextStyle(fontSize: 30));
      },
    ));
  }
}
