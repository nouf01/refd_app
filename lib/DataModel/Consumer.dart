import 'package:cloud_firestore/cloud_firestore.dart';

class Consumer {
  String name;
  String email;
  String phoneNumber;
  int cancelCounter;
  String? profilePhotoURL;
  // Location location;
  // orders list
  // one cart object
  Consumer({
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.cancelCounter,
    this.profilePhotoURL,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'cancelCounter': cancelCounter,
      'profilePhotoURL': profilePhotoURL,
    };
  }

  Consumer.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : name = doc.data()!["name"],
        email = doc.data()!["email"],
        phoneNumber = doc.data()!["phoneNumber"],
        cancelCounter = doc.data()!["cancelCounter"],
        profilePhotoURL = doc.data()!["profilePhotoURL"];

  String getName() {
    return name;
  }

  String getEmail() {
    return email;
  }

  String getPhoneNumber() {
    return phoneNumber;
  }

  int getCancelCounter() {
    return cancelCounter;
  }
}
