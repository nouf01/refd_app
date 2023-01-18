import 'dart:io';
import 'dart:math';

import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Provider.dart';

import 'DailyMenu_Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  canceled,
  waitingForPickUp,
  underProcess,
  pickedUp,
}

class Order_object {
  final String _orderID;
  final DateTime _date;
  final String _status;
  //Timer processTimer;
  //Timer pickUpTimer;
  final double _total;
  final String _providerID;
  final String _consumerID;
  final String _providerLogo;
  final String _providerName;

  Order_object({
    required date,
    required total,
    required providerID,
    required consumerID,
    required status,
    required providerLogo,
    required providerName,
  })  : this._status = status.toString().replaceAll('Order_status.', ''),
        this._orderID =
            ((new Random()).nextInt(900000000) + 100000000).toString(),
        this._date = date,
        this._total = total,
        this._providerID = providerID,
        this._consumerID = consumerID,
        this._providerLogo = providerLogo,
        this._providerName = providerName;

  Map<String, dynamic> toMap() {
    return {
      'orderID': _orderID,
      'date': _date,
      'total': _total,
      'providerID': _providerID,
      'consumerID': _consumerID,
      'status': _status,
      'providerLogo': _providerLogo,
      'providerName': _providerName,
    };
  }

  Order_object.fromMap(Map<String, dynamic> orderMap)
      : _providerID = orderMap["providerID"],
        _orderID = orderMap["orderID"],
        _date = orderMap["date"],
        _consumerID = orderMap["consumerID"],
        _status = orderMap["status"],
        _providerLogo = orderMap['providerLogo'],
        _providerName = orderMap['providerName'],
        _total = orderMap['total'];

  Order_object.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : _orderID = doc.data()!['orderID'],
        _date = doc
            .data()!['date']
            .toDate(), //_dateTime.parse(doc.data()!['__orderID']),
        _total = doc.data()!["total"],
        _providerID = doc.data()!["providerID"],
        _consumerID = doc.data()!["consumerID"],
        _status = doc.data()!["status"],
        _providerName = doc.data()!["providerName"],
        _providerLogo = doc.data()!["providerLogo"];

  get getorderID => this._orderID;

  get getdate => this._date;

  get get_status => this._status.toString().replaceAll('Order_status.', '');

  get get_total => this._total;

  get get_ProviderID => this._providerID;

  get get_consumerID => this._consumerID;
  get getProviderName => this._providerName;

  static convert_date(DocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data()!['date'];
  }

  get getProviderLogo => this._providerLogo;
}
