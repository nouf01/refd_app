// ignore_for_file: sort_child_properties_last

import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refd_app/LoginSignUp/providerSign/ProviderLogIn.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';
import '../../DataModel/DB_Service.dart';
import '../../DataModel/Provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flexi_chip/flexi_chip.dart';

class ProviderSignUp extends StatefulWidget {
  final double providerLat;
  final double providerLong;

  const ProviderSignUp({super.key, required providerLat, required providerLong})
      : this.providerLat = providerLat,
        this.providerLong = providerLong;
  @override
  State<ProviderSignUp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<ProviderSignUp> {
  //firebase database
  Database db = Database();
  late Provider newProvider;

  //text field values
  var userName,
      userRegNumber,
      userPhoneNumber,
      userEmail,
      UserPassword,
      UserConfirmpassword,
      userLat,
      UserLang;

  //the key for the form
  final formKey = GlobalKey<FormState>();

  //passsword confirmation method
  bool passwordConfirmed() {
    if (UserPassword == UserConfirmpassword)
      return true;
    else {
      showDialog(
          context: this.context,
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

  //upload image
  var storage = FirebaseStorage.instance;
  String? image_URL;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image uploaded');
      }
    });
  }

  //provider tags
  List<Tags> listTags = [
    Tags.coffee,
    Tags.grocery,
    Tags.pizza,
    Tags.bakery,
    Tags.sweets,
    Tags.fastFood,
    Tags.jucies,
    Tags.grill,
    Tags.saudi,
  ];
  List<Tags> choosedTags = []; //choosed tags
  int tag = 0;

  Future uploadFile() async {
    if (_photo == null) {
      return;
    }
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
      image_URL = await ref.getDownloadURL();
    } catch (e) {
      print('Error Occured');
    }
  }

  //sign up method
  ProviderSignUpFunc() async {
    var formFields = formKey.currentState;
    if (formFields!.validate()) {
      if (passwordConfirmed()) {
        formFields.save();
        try {
          final credential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: userEmail,
            password: UserPassword,
          );
          print('11111111111111111111111111111111111111111111');
          print(userName);
          print(userRegNumber);
          print(userEmail);
          print(userPhoneNumber);
          print(choosedTags);
          print(userLat);
          print(UserLang);
          newProvider = Provider(
            commercialName: userName,
            commercialReg: userRegNumber,
            email: userEmail,
            phoneNumber: userPhoneNumber,
            accountStatus: Status.Active,
            rate: 2.5,
            tagList: choosedTags,
            uid: credential.user!.uid,
            logoURL: image_URL,
            Lat: widget.providerLat, //double.parse("$userLat"),
            Lang: widget.providerLong, //double.parse("$UserLang"));
          );
          var otherUser = types.User(
            firstName: newProvider!.get_commercialName,
            id: newProvider!.get_uid(),
            imageUrl: image_URL,
            lastName: newProvider!.get_commercialName,
          );
          await FirebaseChatCore.instance.createUserInFirestore(otherUser);
          await db.addNewProviderToFirebase(newProvider);

          return newProvider;
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            showDialog(
                context: this.context,
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
                context: this.context,
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
          print('333333333333333333333333333333333333333333333333333333');
          print(e);
        }
      } else {
        print('44444444444444444444444444444444444444444444444444444444444444');
      }
    }
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
                          userName = newValue;
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
                              borderSide: BorderSide(color: Color(0xFF89CDA7)),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100.0)),
                              borderSide: BorderSide(
                                  width: 3, color: Color(0xFF89CDA7))),
                          label: Text(
                            "Commercial name",
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
                          userRegNumber = newValue;
                        },
                        validator: (value) {
                          if (value!.isEmpty)
                            return "Commercial register number";
                          else
                            return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "Commercial register number",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.numbers,
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
                          userPhoneNumber = newValue;
                        },
                        validator: (value) {
                          if (value!.isEmpty)
                            return "phone number";
                          else
                            return null;
                        },
                        decoration: const InputDecoration(
                          hintText: "phone number",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
                          prefixIcon: Icon(
                            Icons.phone,
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
                          hintText: "Email",
                          hintStyle:
                              TextStyle(fontSize: 14, color: Colors.grey),
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
                    height: 20,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 7),
                    width: 365,
                    height: 50,
                    child: TextFormField(
                        onSaved: (newValue) {
                          UserConfirmpassword = newValue;
                        },
                        obscureText: true,
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
                            "Confirm password",
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: 280,
                    child: Text(
                      "category",
                      textAlign: TextAlign.left,
                      style: TextStyle(fontSize: 20, color: Color(0xFF89CDA7)),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    height: 150,
                    child: ChipsChoice<Tags>.multiple(
                      wrapped: true,
                      value: choosedTags,
                      onChanged: ((value) {
                        setState(() {
                          choosedTags = value;
                        });
                      }),
                      choiceItems: C2Choice.listFrom(
                        source: listTags,
                        value: (i, v) => v,
                        label: (i, v) => v.toString().replaceAll('Tags.', ''),
                      ),
                      choiceStyle: FlexiChipStyle.when(
                          selected: const C2ChipStyle(
                              checkmarkColor: Color(0xFF89CDA7),
                              backgroundColor: Color(0xFF89CDA7),
                              foregroundStyle: TextStyle(color: Colors.black))),
                      choiceCheckmark: true,
                    ),
                  ),
                  Container(
                    width: 330,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () {
                          //pickercamera();
                          imageFromGallery();
                        },
                        child: const Text(
                          "Upload image",
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
                    height: 15,
                  ),
                  Container(
                    width: 330,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () async {
                          Provider currentProvider = await ProviderSignUpFunc();
                          if (currentProvider != null) {
                            String result = currentProvider.get_email;

                            print(" $result ");
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProviderLogIn()),
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
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProviderLogIn()),
                            );
                          },
                          child: const Text(
                            "Log in",
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
