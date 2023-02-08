import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:flexi_chip/flexi_chip.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/LoginSignUp/UserType.dart';
import 'package:refd_app/LoginSignUp/updatePassword.dart';

import '../../DataModel/DB_Service.dart';

class ProviderProfile extends StatefulWidget {
  @override
  State<ProviderProfile> createState() => _MyConsumerProfileState();
}

class _MyConsumerProfileState extends State<ProviderProfile> {
  //the key for the form
  final formKey = GlobalKey<FormState>();

  //firebase variables
  Database _db = Database();
  var _currentProvider;
  var _currentUser;

  //user info
  var _userEmail, _provname, _provphoneNumber, _logoURL, _commercialReg, _tags;

  //controler
  //provider tags
  List<Tags> _listTags = [
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
  List<Tags> _choosedTags = []; //choosed tags
  int tag = 0;

//upload image
  var _storage = FirebaseStorage.instance;
  String? _image_URL;
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

  Future uploadFile() async {
    if (_photo == null) {
      return;
    }
    final fileName = basename(_photo!.path);
    final destination = 'files/$fileName';

    try {
      final ref = FirebaseStorage.instance.ref(destination).child('file/');
      await ref.putFile(_photo!);
      _image_URL = await ref.getDownloadURL();
      _logoURL = _image_URL;
    } catch (e) {
      print('Error Occured');
    }
  }

//get the user that is logged in
  _getCurrentUserInfo() {
    final _auth = FirebaseAuth.instance.currentUser;
    _userEmail = _auth!.email!.toString();
    return _auth;
  }

//get current consumer info (email, name, phone number)
  Future setCurrentUserInfo() async {
    _currentUser = _getCurrentUserInfo();
    _currentUser = FirebaseAuth.instance.currentUser;
    _userEmail = _currentUser!.email!.toString();
    if (_currentUser != null) {
      _db = Database();
      _currentProvider = Provider.fromDocumentSnapshot(
          await _db.searchForProvider("$_userEmail"));

      _provname = _currentProvider.get_commercialName;
      _provphoneNumber = _currentProvider.get_phoneNumber;
      _logoURL = _currentProvider.get_logoURL;
      _commercialReg = _currentProvider.get_commercialReg;
      _tags = _currentProvider.get_tags;
    }
  }

  //update user info
  UpdateProviderInfo() {
    var formFields = formKey.currentState;
    if (formFields!.validate()) {
      formFields.save();
      _db.addToProviderTags(_userEmail, _choosedTags);
      if (_choosedTags.length != 0) {
        _db.updateProviderInfo(_userEmail, true, _provname, {
          'commercialName': _provname,
          'commercialReg': _commercialReg,
          'phoneNumber': _provphoneNumber,
          'tags': _choosedTags
        });
      } else {
        _db.updateProviderInfo(_userEmail, true, _provname, {
          'commercialName': _provname,
          'commercialReg': _commercialReg,
          'phoneNumber': _provphoneNumber,
          'tags': _tags
        });
      }

      showDialog(
          context: this.context,
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
      setState(() {
        if (_choosedTags.length != 0) {
          _db.updateProviderInfo(_userEmail, false, "", {"tags": null});
          _tags = [];
          _choosedTags.forEach((element) {
            _tags.add(element.toString().replaceAll('Tags.', ''));
          });
          _db.updateProviderInfo(_userEmail, false, "", {"tags": _tags});
        }
      });
    }
  }

  //initial state
  @override
  void initState() {
    super.initState();
    setCurrentUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
      future: _db.searchForProvider(_userEmail),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 65,
              backgroundColor: Color(0xFF66CDAA),
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
                    onPressed: () => UpdateProviderInfo(),
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
                    height: 20,
                  ),
                  _logoURL != null
                      ? ClipOval(
                          clipBehavior: Clip.hardEdge,
                          child: Image.network(
                            _logoURL,
                            height: 100,
                            width: 100,
                            fit: BoxFit.cover,
                          ))
                      : Text("Image Not Found"),
                  TextButton(
                      onPressed: imageFromGallery,
                      child: Text(
                        "change profile picture",
                        style: TextStyle(color: Color(0xFF66CDAA)),
                      )),
                  Text("$_provname", style: TextStyle(fontSize: 35)),
                  Text("$_userEmail",
                      style: TextStyle(fontSize: 20, color: Color(0xFF66CDAA))),
                  SizedBox(
                    height: 5,
                  ),
                  Text("$_commercialReg",
                      style: TextStyle(fontSize: 20, color: Color(0xFF66CDAA))),
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
                                _provname = newValue;
                              },
                              validator: (value) {
                                if (value!.length > 30)
                                  return "name can not be more than 30 letters";
                                else if (value.length < 2)
                                  return "name can not be less than 2 letters";
                                else
                                  return null;
                              },
                              initialValue: _provname,
                              decoration: InputDecoration(
                                  labelText: "Name",
                                  labelStyle: TextStyle(fontSize: 17),
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Color(0xFF66CDAA),
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
                                _provphoneNumber = newValue;
                              },
                              validator: (value) {
                                if (value!.isEmpty ||
                                    !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)')
                                        .hasMatch(value))
                                  return "Enter valid phone number";
                                else
                                  return null;
                              },
                              initialValue: _provphoneNumber,
                              decoration: InputDecoration(
                                  labelText: "Phone number",
                                  labelStyle: TextStyle(fontSize: 17),
                                  prefixIcon: Icon(
                                    Icons.phone,
                                    color: Color(0xFF66CDAA),
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
                            width: 300,
                            child: Text(
                              "category",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, color: Color(0xFF66CDAA)),
                            ),
                          ),
                          Container(
                            width: 300,
                            child: Text(
                                _tags
                                    .toString()
                                    .replaceAll('[', '')
                                    .replaceAll(']', ''),
                                style: TextStyle(fontSize: 18),
                                textAlign: TextAlign.left),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          SizedBox(
                            height: 150,
                            child: ChipsChoice<Tags>.multiple(
                              wrapped: true,
                              value: _choosedTags,
                              onChanged: ((value) {
                                setState(() {
                                  _choosedTags = value;
                                });
                              }),
                              choiceItems: C2Choice.listFrom(
                                source: _listTags,
                                value: (i, v) => v,
                                label: (i, v) =>
                                    v.toString().replaceAll('Tags.', ''),
                              ),
                              choiceStyle: FlexiChipStyle.when(
                                  selected: const C2ChipStyle(
                                      checkmarkColor: Color(0xFF66CDAA),
                                      backgroundColor: Color(0xFF66CDAA),
                                      foregroundStyle:
                                          TextStyle(color: Colors.black))),
                              choiceCheckmark: true,
                            ),
                          ),
                        ],
                      )),
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
                              MaterialStateProperty.all(Color(0xFF66CDAA)),
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
                  SizedBox(
                    height: 40,
                  )
                ],
              ),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: SpinKitFadingCube(
              size: 85,
              color: Color(0xFF66CDAA),
            ),
          );
        else
          return Text("error", style: TextStyle(fontSize: 30));
      },
    ));
  }
}
