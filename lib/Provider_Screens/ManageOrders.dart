import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/trackCancelled.dart';
import 'package:refd_app/Consumer_Screens/trackPickedUp.dart';
import 'package:refd_app/Consumer_Screens/trackUnderProcess.dart';
import 'package:refd_app/Consumer_Screens/trackWaiting.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/Provider_Screens/approvUnderProcess.dart';
import 'package:refd_app/Provider_Screens/canceled.dart';
import 'package:refd_app/Provider_Screens/pickedUp.dart';
import 'package:refd_app/Provider_Screens/waitingForPick.dart';

class ManageOrder extends StatefulWidget {
  final Order_object order;

  const ManageOrder({super.key, required this.order});

  @override
  State<ManageOrder> createState() => _ManageOrderState();
}

class _ManageOrderState extends State<ManageOrder> {
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
      Canceled(
          order: widget.order, cancelByProv: widget.order.isCancelledByProv),
      approveUnderProcess(order: widget.order),
      WaitingForPickUp(order: widget.order),
      pickedUp(order: widget.order)
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
      ),
      body: _Pages[whichStatus],
    );
  }
}
