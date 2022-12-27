import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';

class P_card extends StatefulWidget {
  final Provider p;
  const P_card({super.key, required this.p});

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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  title: Text(
                    '${this.widget.p.get_commercialName}',
                    style: TextStyle(fontSize: 18),
                  ),
                  subtitle: Text(
                    ' ${this.widget.p.get_tags}',
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '4.9 Km',
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
                          Icon(
                            star = IconData(
                              0xe5f9,
                              fontFamily: 'MaterialIcons',
                            ),
                            color: Colors.yellow,
                          ),
                          Text('${this.widget.p.get_rate}'),
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
