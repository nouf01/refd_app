import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/DataModel/Order.dart';

class OrderCard extends StatefulWidget {
  final Order_object order;
  const OrderCard({super.key, required this.order});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Number: ${this.widget.order.getorderID}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 8),
            Text(
              'Date: ${this.widget.order.getdate.toString()}',
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
                      Text(
                        '${this.widget.order.get_status}',
                        style: TextStyle(fontSize: 13),
                      ),
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
    );
  }
}
