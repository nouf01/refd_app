import 'dart:io';
import 'dart:math';

import 'DailyMenu_Item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus {
  canceled,
  waitingForPickUp,
  underProcess,
  pickedUp,
}

class Order_object {
  final String orderID;
  final DateTime date;
  final String status;
  //Timer processTimer;
  //Timer pickUpTimer;
  final double total;
  final String providerID;
  final String consumerID;

  Order_object({
    required this.date,
    required this.total,
    required this.providerID,
    required this.consumerID,
    required status,
  })  : this.status = status.toString().replaceAll('OrderStatus.', ''),
        orderID = ((new Random()).nextInt(900000000) + 100000000).toString();

  Map<String, dynamic> toMap() {
    return {
      'orderID': orderID,
      'date': date,
      'total': total,
      'providerID': providerID,
      'consumerID': consumerID,
      'status': status,
    };
  }

  Order_object.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : orderID = doc.data()!['orderID'],
        date = doc
            .data()!['date']
            .toDate(), //DateTime.parse(doc.data()!['orderID']),
        total = doc.data()!["total"],
        providerID = doc.data()!["providerID"],
        consumerID = doc.data()!["consumerID"],
        status = doc.data()!["status"];

  get getOrderID => this.orderID;

  get getDate => this.date;

  get getStatus => this.status;

  get getTotal => this.total;

  get getProviderID => this.providerID;

  get getConsumerID => this.consumerID;

  static convertDate(DocumentSnapshot<Map<String, dynamic>> doc) {
    return doc.data()!['date'];
  }
}
