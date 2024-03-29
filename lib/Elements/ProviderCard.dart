import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/restaurantDetail.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/Provider_Screens/Menu.dart';

class P_card extends StatefulWidget {
  final Provider p;
  final double lat;
  final double long;
  const P_card(
      {super.key, required this.p, required this.lat, required this.long});

  @override
  State<P_card> createState() => _PCardState();
}

class _PCardState extends State<P_card> {
  @override
  Widget build(BuildContext context) {
    IconData star;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: InkWell(
        onTap: () {
          //move to resturant page
        },
        child: Card(
          color: Colors.white,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Image.network(
                  '${this.widget.p.get_logoURL}',
                  fit: BoxFit.fill,
                ),
              ),
              Expanded(
                flex: 5,
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                restaurantDetail(currentProv: this.widget.p)));
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  title: Text(
                    '${this.widget.p.get_commercialName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    ' ${widget.p.get_tags.toString().replaceAll('[', '').replaceAll(']', '')}',
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '${this.widget.p.calculateDistance(widget.lat, widget.long).toStringAsFixed(2)} ',
                      style: TextStyle(fontSize: 15),
                    ), //ditance caculate it based on so,thing
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: <Widget>[
                          Text(
                              '${this.widget.p.get_rate.toString().substring(0, 3)}'),
                          Icon(
                            star = IconData(
                              0xe5f9,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: Colors.yellow,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
