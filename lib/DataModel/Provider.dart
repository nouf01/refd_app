import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
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
  final String _logoURL;
  final String _commercialName;
  final String _commercialReg;
  final String _email;
  final String _phoneNumber;
  final String _accountStatus;
  final List<String> _tags;
  final double _rate;
  final int _NumberOfItemsInDM;
  final List<String> _searchCases;
  final double _Lat;
  final double _Lang;
  String _uid;
  String _token;
  int _isOpenNow = 1;
  int _totalMeals = 0;
  double _totalSales = 0.0001;

  //List<Item>? itemsList;
  //location
  // orders list
  //catagory: what about _tags?

  Provider(
      {required logoURL,
      required commercialName,
      required commercialReg,
      required email,
      required phoneNumber,
      required accountStatus,
      required rate,
      required tagList,
      required Lat,
      required uid,
      required Lang})
      : _NumberOfItemsInDM = 0,
        this._accountStatus =
            accountStatus.toString().replaceAll('Status.', ''),
        this._searchCases = setSearchParam(commercialName),
        this._tags = set_tags(tagList),
        this._logoURL = logoURL,
        this._commercialName = commercialName,
        this._commercialReg = commercialReg,
        this._email = email.toString().toLowerCase(),
        this._phoneNumber = phoneNumber,
        this._uid = uid,
        this._token = '',
        this._rate = rate,
        this._Lat = Lat,
        this._Lang = Lang;

  static List<String> setSearchParam(String caseNumber) {
    caseNumber = caseNumber.toLowerCase();
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  static List<String> set_tags(List<Tags> tagList) {
    List<String> result = [];
    tagList.forEach((e) {
      result.add(e.toString().replaceAll('Tags.', ''));
    });
    return result;
  }

  Map<String, dynamic> toMap() {
    return {
      'logoURL': _logoURL,
      'commercialName': _commercialName,
      'commercialReg': _commercialReg,
      'email': _email.toLowerCase(),
      'phoneNumber': _phoneNumber,
      'accountStatus': _accountStatus,
      'rate': _rate,
      'NumberOfItemsInDM': _NumberOfItemsInDM,
      'searchCases': _searchCases,
      'isOpenNow': _isOpenNow,
      'totalSales': _totalSales,
      'totalMeals': _totalMeals,
      'token': _token,
      'tags': _tags,
      'Lat': _Lat,
      'Lang': _Lang,
      'uid': _uid,
    };
  }

  Provider.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : _commercialName = doc.data()!["commercialName"],
        _logoURL = doc.data()!['logoURL'],
        _commercialReg = doc.data()!["commercialReg"],
        _email = doc.data()!["email"],
        _phoneNumber = doc.data()!["phoneNumber"],
        _accountStatus = doc.data()!["accountStatus"],
        _uid = doc.data()!['uid'],
        _rate = doc.data()!["rate"],
        _NumberOfItemsInDM = doc.data()!['NumberOfItemsInDM'],
        _tags = doc.data()?["tags"].cast<String>(),
        _searchCases = doc.data()?["searchCases"].cast<String>(),
        _token = doc.data()!['token'],
        _totalMeals = doc.data()!['totalMeals'],
        _totalSales = doc.data()!['totalSales'],
        _isOpenNow = doc.data()!['isOpenNow'],
        _Lat = doc.data()!["Lat"],
        _Lang = doc.data()!["Lang"];

  //String? get getUid => this.uid;
  //set setUid(String? uid) => this.uid = uid;

  get get_commercialName => this._commercialName;

  String get_uid() {
    return _uid;
  }

  get get_commercialReg => this._commercialReg;

  get get_email => this._email;

  get get_phoneNumber => this._phoneNumber;

  get get_accountStatus => this._accountStatus;

  get get_rate => this._rate;

  int get get_NumberOfItemsInDM => this._NumberOfItemsInDM;

  get get_tags => this._tags;

  get get_searchCases => this._searchCases;

  get get_logoURL => this._logoURL;

  get get_Lat => this._Lat;

  get get_Lang => this._Lang;

  get get_token => this._token;

  int get_isOpen() {
    return this._isOpenNow;
  }

  set setIsOpenNow(int value) {
    this._isOpenNow = value;
  }

  get totalMeals => this._totalMeals;

  set totalMeals(value) => this._totalMeals = value;

  get totalSales => this._totalSales;

  set totalSales(value) => this._totalSales = value;

  double calculateDistance(lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - this._Lat) * p) / 2 +
        c(this._Lat * p) * c(lat2 * p) * (1 - c((lon2 - this._Lang) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  double getLang() {
    return _Lang;
  }

  double getLat() {
    return _Lat;
  }

  /*void set_commercialName(_commercialName) {
    this._commercialName = _commercialName;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'_commercialName': _commercialName});
  }
  void set_commercialReg(_commercialReg) {
    this._commercialReg = _commercialReg;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'_commercialReg': _commercialReg});
  }
  set set_NumberOfItemsInDM(int _NumberOfItemsInDM) =>
      this._NumberOfItemsInDM = _NumberOfItemsInDM;
  void set_email(_email) {
    this._email = _email;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'_email': _email});
  }  
  void set_accountStatus(Status status) {
    this._accountStatus = status.toString().replaceAll('Status.', '');
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'_accountStatus': status.toString().replaceAll('Status.', '')});
  }
  void set_rate(_rate) {
    this._rate = _rate;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'_rate': _rate});
  }
  void setUsername(username) {
    this.username = username;
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(this.username)
        .update({'username': username});
  }*/
}
