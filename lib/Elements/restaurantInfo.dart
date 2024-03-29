import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DataModel/Provider.dart';

class restaurantInfo extends StatefulWidget {
  final Provider currentProve;
  const restaurantInfo({super.key, required this.currentProve});

  @override
  State<restaurantInfo> createState() => _restaurantInfo();
}

class _restaurantInfo extends State<restaurantInfo> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(96, 154, 154, 154),
            offset: const Offset(
              3.0,
              3.0,
            ),
            blurRadius: 5.0,
            spreadRadius: 2.0,
          ),
        ],
      ),
      child: Card(
        color: Color(0xFF89CDA7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Padding(
                    padding: const EdgeInsets.only(right: 10, left: 23),
                    child: ClipOval(
                        clipBehavior: Clip.hardEdge,
                        child: Image.network(
                          this.widget.currentProve.get_logoURL,
                          height: 120,
                          width: 90,
                          fit: BoxFit.cover,
                        ))),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  textDirection: TextDirection.ltr,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      this.widget.currentProve.get_commercialName,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                      ),
                    ),
                    Text(
                      ' ${widget.currentProve.get_tags.toString().replaceAll('[', '').replaceAll(']', '')}',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 20,
                        ),
                        Text(this.widget.currentProve.get_rate.toString(),
                            style: TextStyle(
                              color: Colors.white,
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
