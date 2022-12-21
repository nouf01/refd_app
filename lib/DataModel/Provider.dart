import 'package:cloud_firestore/cloud_firestore.dart';

import 'item.dart';

enum Status {
  Active,
  Suspended,
}

enum Tags {
  coffee,
  bakery,
  grill,
  seaFood,
  jucies,
  sweets,
  pastries,
  grocery,
  american,
  italian,
  asian,
  indian,
  fastFood,
  beverages,
  healthey,
  saudi,
  sushi,
  lebanese,
  salads,
  pizza,
  roastery,
}

class Provider {
  final String username;
  final String? logoURL;
  final String commercialName;
  final String commercialReg;
  final String email;
  final String phoneNumber;
  final String accountStatus;
  final List<String>
      tags; //actually i dont use this here in the object get it as query from db_service
  final double rate;
  final int NumberOfItemsInDM;

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
    required accountStatus,
    required this.rate,
  })  : NumberOfItemsInDM = 0,
        this.accountStatus = accountStatus.toString().replaceAll('Status.', ''),
        tags = [];

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'logoURL:': logoURL,
      'commercialName': commercialName,
      'commercialReg': commercialReg,
      'email': email,
      'phoneNumber': phoneNumber,
      'accountStatus': accountStatus,
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
        rate = doc.data()!["rate"],
        NumberOfItemsInDM = doc.data()!['NumberOfItemsInDM'],
        tags = doc.data()?["tags"].cast<String>();

  //String? get getUid => this.uid;
  //set setUid(String? uid) => this.uid = uid;

  get getUsername => this.username;

  get getCommercialName => this.commercialName;

  get getCommercialReg => this.commercialReg;

  get getEmail => this.email;

  get getPhoneNumber => this.phoneNumber;

  get getAccountStatus => this.accountStatus;

  get getRate => this.rate;

  int get getNumberOfItemsInDM => this.NumberOfItemsInDM;

  /*void setCommercialName(commercialName) {
    this.commercialName = commercialName;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'commercialName': commercialName});
  }

  void setCommercialReg(commercialReg) {
    this.commercialReg = commercialReg;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'commercialReg': commercialReg});
  }

  set setNumberOfItemsInDM(int NumberOfItemsInDM) =>
      this.NumberOfItemsInDM = NumberOfItemsInDM;

  void setEmail(email) {
    this.email = email;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'email': email});
  }  

  void setAccountStatus(Status status) {
    this.accountStatus = status.toString().replaceAll('Status.', '');
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'accountStatus': status.toString().replaceAll('Status.', '')});
  }

  void setRate(rate) {
    this.rate = rate;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'rate': rate});
  }

  void setUsername(username) {
    this.username = username;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'username': username});
  }*/
}
