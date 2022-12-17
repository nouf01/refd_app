import 'package:cloud_firestore/cloud_firestore.dart';

class Consumer {
  String? uid;
  String name;
  String email;
  String phoneNumber;
  int cancelCounter;
  //Final Location location;
  // orders list
  // one cart object
  Consumer({
    this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.cancelCounter,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'cancelCounter': cancelCounter,
    };
  }

  Consumer.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        name = doc.data()!["name"],
        email = doc.data()!["email"],
        phoneNumber = doc.data()!["phoneNumber"],
        cancelCounter = doc.data()!["cancelCounter"];

  void setName(newName) {
    name = newName;
  }

  void setEmail(newEmail) {
    email = newEmail;
  }

  void setPhoneNumber(newPhoneNumber) {
    phoneNumber = newPhoneNumber;
  }

  void incrementCancelCounter() {
    cancelCounter++;
  }

  void decrementCancelCounter() {
    cancelCounter--;
  }

  String? getId() {
    return uid;
  }

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
