// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/item.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:refd_app/Provider_Screens/DailyMenu.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/Menu.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';
import 'ProvHome.dart';
import 'package:firebase_storage/firebase_storage.dart';

class EditScreen extends StatefulWidget {
  Item currentItem;
  EditScreen({super.key, required this.currentItem});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
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

  @override
  void initState() {
    image_URL = widget.currentItem.get_imageURL();
    setState(() {});
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
      setState(() {});
    } catch (e) {
      print('Error Occured');
    }
  }

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
        title: Text('Edit Item'),
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
                          child:
                              Image.network(widget.currentItem.get_imageURL()))
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
                SizedBox(height: 25),
                SizedBox(
                  width: 355,
                  height: 45,
                  child: TextFormField(
                    onSaved: (newValue) {
                      print('Helllllllllllllllllllllllllo');
                      itemName = newValue!;
                      setState(() {});
                    },
                    initialValue: widget.currentItem.get_name(),
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
                    initialValue: widget.currentItem
                        .get_originalPrice()
                        .toStringAsFixed(2),
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
                    initialValue: widget.currentItem.getDecription(),
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
                          Database db = Database();
                          db.updateItemInfo(
                              widget.currentItem.getId(), widget.currentItem, {
                            'name': itemName!,
                            'originalPrice': double.parse(itemPrice!),
                            'description': itemDescrib!,
                            'imageURL': image_URL,
                          });
                          Item t = Item(
                              providerID: widget.currentItem.get_providerID,
                              name: itemName,
                              description: itemDescrib,
                              originalPrice: double.parse(itemPrice!),
                              imageURL: image_URL);
                          t.set_inDM(widget.currentItem.get_inDM());
                          //search for daily menu item and change it
                          double dis = (await FirebaseFirestore.instance
                                  .collection('Providers')
                                  .doc(t.get_providerID)
                                  .collection('DailyMenu')
                                  .doc(widget.currentItem.getId())
                                  .get())
                              .data()!['discount'];
                          await FirebaseFirestore.instance
                              .collection('Providers')
                              .doc(widget.currentItem.get_providerID)
                              .collection('DailyMenu')
                              .doc(widget.currentItem.getId())
                              .update({
                            'item': t.toMap(),
                            'priceAfterDiscount': t.get_originalPrice() -
                                (t.get_originalPrice() * dis)
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xFF66CDAA)),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: const Text(
                        "Update",
                        selectionColor: Colors.white,
                        style: TextStyle(fontSize: 27),
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
