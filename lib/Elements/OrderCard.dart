import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/Provider_Screens/OrderStatus.dart';
import 'package:refd_app/Provider_Screens/waitingPickUp.dart';

import '../Provider_Screens/underProcess.dart';

class OrderCard extends StatefulWidget {
  final Order_object order;
  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.order.get_status == 'underProcess') {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => underProcess(order: widget.order)));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => waitingForPick(order: widget.order)));
        }
      },
      child: Container(
        /*shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.black),
        ),
        elevation: 0,*/
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black), color: Colors.white),
        //color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '# ${this.widget.order.getorderID}',
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                'Date: ${this.widget.order.getdate.toString().substring(0, 16)}',
                style: TextStyle(fontSize: 13),
              ),
              Divider(thickness: 2),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Status',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        getTheStatus('${this.widget.order.get_status}'),
                      ],
                    ),
                    VerticalDivider(thickness: 1),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${this.widget.order.get_total}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    VerticalDivider(thickness: 1),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Consumer:',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          '${this.widget.order.get_consumerID}',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                    VerticalDivider(thickness: 1),
                  ],
                ),
              ),
              Divider(thickness: 2),
              Icon(Icons.timer, color: Colors.black),
              SizedBox(width: 8),
              Text('Timer Here'),
            ],
          ),
        ),
      ),
    );
  }
}

Widget getTheStatus(String status) {
  if (status == 'underProcess') {
    return const Text(
      'Under Process',
      style: TextStyle(color: Colors.blue, fontSize: 10),
    );
  } else if (status == 'waitingForPickUp') {
    return const Text(
      'Waiting for pick up',
      style: TextStyle(color: Color.fromARGB(255, 202, 156, 41), fontSize: 10),
    );
  } else if (status == 'pickedUp') {
    return const Text(
      'Picked Up',
      style: TextStyle(color: Color(0xFF66CDAA), fontSize: 10),
    );
  } else if (status == 'canceled') {
    return const Text(
      'Canceled',
      style: TextStyle(color: Colors.red, fontSize: 10),
    );
  } else {
    return const Text(
      'No Status',
      style: TextStyle(color: Colors.grey, fontSize: 10),
    );
  }
}
