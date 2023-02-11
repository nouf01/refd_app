import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:refd_app/Consumer_Screens/trackCancelled.dart';
import 'package:refd_app/Consumer_Screens/trackPickedUp.dart';
import 'package:refd_app/Consumer_Screens/trackUnderProcess.dart';
import 'package:refd_app/Consumer_Screens/trackWaiting.dart';
import 'package:refd_app/DataModel/Order.dart';

import 'ConsumerNavigation.dart';

class trackOrder extends StatefulWidget {
  Order_object order;
  trackOrder({super.key, required this.order});

  @override
  State<trackOrder> createState() => _trackOrderState();
}

class _trackOrderState extends State<trackOrder> {
  late List<Widget> _Pages;
  late int whichStatus;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.order.get_status == OrderStatus.canceled.toString()) {
      whichStatus = 0;
    } else if (widget.order.get_status == OrderStatus.underProcess.toString()) {
      whichStatus = 1;
    } else if (widget.order.get_status ==
        OrderStatus.waitingForPickUp.toString()) {
      whichStatus = 2;
    } else if (widget.order.get_status == OrderStatus.pickedUp.toString()) {
      whichStatus = 3;
    }
    _Pages = [
      trackCancelled(
          orderID: widget.order.getorderID,
          cancelByProv: widget.order.isCancelledByProv),
      trackUnderProcess(order: widget.order),
      trackWaiting(orderID: widget.order.getorderID),
      trackPickedUp(orderID: widget.order.getorderID)
    ];
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Order Status'),
        backgroundColor: Color(0xFF89CDA7),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => ConsumerNavigation(choosedIndex: 2)),
              (Route<dynamic> route) => false,
            );
          },
        ),
      ),
      body: _Pages[whichStatus],
    );
  }
}
