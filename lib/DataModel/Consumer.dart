import 'package:cloud_firestore/cloud_firestore.dart';

class Consumer {
  String _name;
  String _email;
  String _phoneNumber;
  int _cancelCounter;
  String? _profilePhotoURL;
  // Location location;
  // orders list
  // one cart object
  Consumer({
    required name,
    required email,
    required phoneNumber,
    required cancelCounter,
    required profilePhotoURL,
  })  : this._name = name,
        this._cancelCounter = cancelCounter,
        this._email = email,
        this._phoneNumber = phoneNumber,
        this._profilePhotoURL = profilePhotoURL;

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'email': _email,
      'phoneNumber': _phoneNumber,
      'cancelCounter': _cancelCounter,
      'profilePhotoURL': _profilePhotoURL,
    };
  }

  Consumer.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : _name = doc.data()!["name"],
        _email = doc.data()!["email"],
        _phoneNumber = doc.data()!["phoneNumber"],
        _cancelCounter = doc.data()!["cancelCounter"],
        _profilePhotoURL = doc.data()!["profilePhotoURL"];

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
}
