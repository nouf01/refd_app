import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/item.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:refd_app/Provider_Screens/Menu.dart';
import 'ProvHome.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AddDish extends StatefulWidget {
  //final Function(Item) addDish;

  AddDish(/*this.addDish*/);

  @override
  _AddDish createState() => _AddDish();
}

class _AddDish extends State<AddDish> {
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
          keyboardType: isNum ? TextInputType.number : TextInputType.text,
          inputFormatters: isNum
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : <TextInputFormatter>[],
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

    var nameController = TextEditingController();
    var priceController = TextEditingController();
    var desNoController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(8),
          height: 600,
          width: 700,
          child: /*SingleChildScrollView(
            child: */
              Column(
            children: <Widget>[
              Text(
                'Add Item',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: Colors.blueGrey,
                ),
              ),
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
              buildTextField('Name', nameController, false),
              buildTextField('Original Price', priceController, true),
              buildTextField('Description', desNoController, false),
              ElevatedButton(
                onPressed: () {
                  final dish = Item(
                      providerID: 'MunchBakery@mail.com',
                      name: nameController.text,
                      originalPrice: double.parse(priceController.text),
                      description: desNoController.text,
                      imageURL: image_URL);
                  Database db = Database();
                  db.addToProviderMenu(dish);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MenuScreen()));
                },
                child: Text('ADD'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
