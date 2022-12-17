import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

class Provider {
  String username;
  String? logoURL;
  String commercialName;
  String commercialReg;
  String email;
  String phoneNumber;
  String accountStatus;
  String cuisine;
  double rate;
  int NumberOfItemsInDM;

  //List<Item>? itemsList;
  //location
  // orders list
  //catagory: what about tags?

  Provider({
    required this.username,
    this.logoURL,
    required this.commercialName,
    required this.commercialReg,
    required this.email,
    required this.phoneNumber,
    required this.accountStatus,
    required this.cuisine,
    required this.rate,
  }) : NumberOfItemsInDM = 0;

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'logoURL:': logoURL,
      'commercialName': commercialName,
      'commercialReg': commercialReg,
      'email': email,
      'phoneNumber': phoneNumber,
      'accountStatus': accountStatus,
      'cuisine': cuisine,
      'rate': rate,
      'NumberOfItemsInDM': NumberOfItemsInDM
    };
  }

  Provider.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : username = doc.data()!['username'],
        logoURL = doc.data()!['logoURL'],
        commercialName = doc.data()!["commercialName"],
        commercialReg = doc.data()!["commercialReg"],
        email = doc.data()!["email"],
        phoneNumber = doc.data()!["phoneNumber"],
        accountStatus = doc.data()!["accountStatus"],
        cuisine = doc.data()!["cuisine"],
        rate = doc.data()!["rate"],
        NumberOfItemsInDM = doc.data()!['NumberOfItemsInDM'];

  //String? get getUid => this.uid;
  //set setUid(String? uid) => this.uid = uid;

  get getUsername => this.username;

  void setUsername(username) {
    this.username = username;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'username': username});
  }

  get getCommercialName => this.commercialName;

  void setCommercialName(commercialName) {
    this.commercialName = commercialName;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'commercialName': commercialName});
  }

  get getCommercialReg => this.commercialReg;

  void setCommercialReg(commercialReg) {
    this.commercialReg = commercialReg;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'commercialReg': commercialReg});
  }

  get getEmail => this.email;

  void setEmail(email) {
    this.email = email;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'email': email});
  }

  get getPhoneNumber => this.phoneNumber;

  set setPhoneNumber(phoneNumber) {
    this.phoneNumber = phoneNumber;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'phoneNumber': phoneNumber});
  }

  get getAccountStatus => this.accountStatus;

  set setAccountStatus(accountStatus) {
    this.accountStatus = accountStatus;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'accountStatus': accountStatus});
  }

  get getCuisine => this.cuisine;

  void setCuisine(cuisine) {
    this.cuisine = cuisine;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'cuisine': cuisine});
  }

  get getRate => this.rate;

  void setRate(rate) {
    this.rate = rate;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'rate': rate});
  }

  int get getNumberOfItemsInDM => this.NumberOfItemsInDM;
  set setNumberOfItemsInDM(int NumberOfItemsInDM) =>
      this.NumberOfItemsInDM = NumberOfItemsInDM;
}
