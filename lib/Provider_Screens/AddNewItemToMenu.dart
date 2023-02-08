import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/item.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/Menu.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';
import 'ProvHome.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddDish extends StatefulWidget {
  //final Function(Item) addDish;

  AddDish(/*this.addDish*/);

  @override
  _AddDish createState() => _AddDish();
}

class _AddDish extends State<AddDish> {
  final _formKey = GlobalKey<FormState>();
  var storage = FirebaseStorage.instance;
  String image_URL = '';
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
      image_URL = await ref.getDownloadURL();
    } catch (e) {
      print('Error Occured');
    }
  }

  /*void pickercamera() async {
    final myfile = await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(myfile!.path);
    });
    if (myfile != null) {
      var imageFile = File(myfile!.path);
      var imageName = basename(imageFile.path);
      var ref = FirebaseStorage.instance.ref('images/${imageName}');
      await ref.putFile(imageFile);
      setState(() {
        image_URL = (await ref.getDownloadURL()).toString();
      });
      print(
          '-------------------------------------------------------------------');
      print(url);
    } else {
      print('Please upload the item image!');
    }
  }*/

  @override
  Widget build(BuildContext context) {
    Widget buildTextField(
        String hint, TextEditingController controller, bool isNum) {
      return Container(
        margin: EdgeInsets.all(4),
        child: TextField(
          //keyboardType: isNum ? TextInputType.number : TextInputType.text,
          inputFormatters: /*isNum
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]*/
              <TextInputFormatter>[],
          decoration: InputDecoration(
            labelText: hint,
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: Colors.black38,
              ),
            ),
          ),
          controller: controller,
        ),
      );
    }

    var nameController;
    var priceController;
    var desNoController;
    String? itemName;
    String? itemPrice;
    String? itemDescrib;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF66CDAA),
        title: Text('Add New Item'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          height: 700,
          width: 700,
          child: /*SingleChildScrollView(
              child: */
              Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    //pickercamera();
                    imageFromGallery();
                  },
                  child: _photo == null
                      ? Container(
                          height: 250,
                          width: 250,
                          color: Colors.grey,
                          child: Icon(
                            Icons.image,
                            color: Colors.white,
                          ))
                      : Container(
                          height: 250,
                          width: 250,
                          child: ClipRRect(
                            child: Image.file(
                              _photo!,
                              width: 250,
                              height: 250,
                              fit: BoxFit.fitHeight,
                            ),
                          )),
                ),
                SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: 355,
                  height: 45,
                  child: TextFormField(
                    onSaved: (newValue) {
                      print('Helllllllllllllllllllllllllo');
                      itemName = newValue!;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!
                          .isEmpty) /*||
                          !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value))*/
                        return "Enter valid item name";
                      else
                        return null;
                    },
                    obscureText: false,
                    controller: nameController,
                    decoration: InputDecoration(
                        labelText: "Item Name",
                        labelStyle: TextStyle(fontSize: 17),
                        prefixIcon: Icon(
                          Icons.restaurant,
                          color: Color(0xFF66CDAA),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100))),
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
                      itemPrice = newValue.toString();
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!
                          .isEmpty) /*||
                          !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value))*/
                        return "Enter valid price";
                      else
                        return null;
                    },
                    obscureText: false,
                    controller: priceController,
                    decoration: InputDecoration(
                        labelText: "Original Price",
                        labelStyle: TextStyle(fontSize: 17),
                        prefixIcon: Icon(
                          Icons.monetization_on,
                          color: Color(0xFF66CDAA),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100))),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 355,
                  height: 100,
                  child: TextFormField(
                    maxLines: 7,
                    onSaved: (newValue) {
                      itemDescrib = newValue;
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!
                          .isEmpty) /*||
                          !RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)').hasMatch(value))*/
                        return "Enter valid description";
                      else
                        return null;
                    },
                    obscureText: false,
                    controller: desNoController,
                    decoration: InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(fontSize: 17),
                        prefixIcon: Icon(
                          Icons.description,
                          color: Color(0xFF66CDAA),
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100))),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  width: 330,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () async {
                        var formFields = _formKey.currentState;
                        if (formFields!.validate()) {
                          formFields.save();
                          LoggedProvider log = LoggedProvider();
                          final dish = Item(
                              providerID: log.getEmailOnly(),
                              name: itemName!,
                              originalPrice: double.parse(itemPrice!),
                              description: itemDescrib,
                              imageURL: image_URL);
                          Database db = Database();
                          db.addToProviderMenu(dish);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProviderNavigation(
                                        choosedIndex: 1,
                                      )));
                        }
                      },
                      child: const Text(
                        "Add to menu",
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
