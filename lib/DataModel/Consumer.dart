import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/Order.dart';

class Consumer {
  String _name;
  String _email;
  String _phoneNumber;
  int _cancelCounter;
  // Location location;
  // orders list
  double _cartTotal = 0.0;
  int _numOfCartItems = 0;

  Consumer({
    required name,
    required email,
    required phoneNumber,
    required cancelCounter,
    required profilePhotoURL,
  })  : this._name = name,
        this._cancelCounter = cancelCounter,
        this._email = email,
        this._phoneNumber = phoneNumber;

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'email': _email,
      'phoneNumber': _phoneNumber,
      'cancelCounter': _cancelCounter,
      'cartTotal': _cartTotal,
      'numOfCartItems': _numOfCartItems,
    };
  }

  Consumer.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : _name = doc.data()!["name"],
        _email = doc.data()!["email"],
        _phoneNumber = doc.data()!["phoneNumber"],
        _cancelCounter = doc.data()!["cancelCounter"],
        _cartTotal = doc.data()!["cartTotal"],
        _numOfCartItems = doc.data()!["numOfCartItems"];

  String get_name() {
    return _name;
  }

  String get_email() {
    return _email;
  }

  String get_phoneNumber() {
    return _phoneNumber;
  }

  int get_cancelCounter() {
    return _cancelCounter;
  }

  get cartTotal => this._cartTotal;

  get numOfCartItems => this._numOfCartItems;
}
