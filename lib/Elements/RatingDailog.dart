import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';

class RatingDialog extends StatefulWidget {
  final String provID;
  final String orderID;
  const RatingDialog({super.key, required this.provID, required this.orderID});
  @override
  _RatingDialogState createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _stars = 0;

  Widget _buildStar(int starCount) {
    return InkWell(
        child: Icon(
          Icons.star,
          // size: 30.0,
          color: _stars >= starCount ? Colors.orange : Colors.grey,
        ),
        onTap: () {
          setState(() {
            _stars = starCount;
          });
        });
  }

  void updateDatabase(int starCount) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    Database db = Database();
    _stars = starCount;
    if (_stars == 1) {
      int num1stars =
          (await _db.collection('Providers').doc(widget.provID).get())
              .data()!['num1stars'];
      num1stars = num1stars + 1;
      db.updateProviderInfo(widget.provID, false, '', {'num1stars': num1stars});
      db.calculateRate(widget.provID);
      db.updateOrderInfo(widget.orderID, {'hasRate': 1});
    } else if (_stars == 2) {
      int num2stars =
          (await _db.collection('Providers').doc(widget.provID).get())
              .data()!['num2stars'];
      num2stars = num2stars + 1;
      db.updateProviderInfo(widget.provID, false, '', {'num2stars': num2stars});
      db.calculateRate(widget.provID);
      db.updateOrderInfo(widget.orderID, {'hasRate': 1});
    } else if (_stars == 3) {
      int num3stars =
          (await _db.collection('Providers').doc(widget.provID).get())
              .data()!['num3stars'];
      num3stars = num3stars + 1;
      db.updateProviderInfo(widget.provID, false, '', {'num3stars': num3stars});
      db.calculateRate(widget.provID);
      db.updateOrderInfo(widget.orderID, {'hasRate': 1});
    } else if (_stars == 4) {
      int num4stars =
          (await _db.collection('Providers').doc(widget.provID).get())
              .data()!['num4stars'];
      num4stars = num4stars + 1;
      db.updateProviderInfo(widget.provID, false, '', {'num4stars': num4stars});
      db.calculateRate(widget.provID);
      db.updateOrderInfo(widget.orderID, {'hasRate': 1});
    } else if (_stars == 5) {
      int num5stars =
          (await _db.collection('Providers').doc(widget.provID).get())
              .data()!['num5stars'];
      num5stars = num5stars + 1;
      db.updateProviderInfo(widget.provID, false, '', {'num5stars': num5stars});
      db.calculateRate(widget.provID);
      db.updateOrderInfo(widget.orderID, {'hasRate': 1});
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text('Rate the store'),
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildStar(1),
          _buildStar(2),
          _buildStar(3),
          _buildStar(4),
          _buildStar(5),
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
          child: Text('CANCEL'),
          onPressed: Navigator.of(context).pop,
        ),
        ElevatedButton(
          child: Text('OK'),
          onPressed: () {
            updateDatabase(_stars);
            Navigator.of(context).pop(_stars);
          },
        )
      ],
    );
  }
}
