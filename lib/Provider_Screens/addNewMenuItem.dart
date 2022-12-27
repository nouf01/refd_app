import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/item.dart';

class addNewMenuItem extends StatefulWidget {
  const addNewMenuItem({super.key});

  @override
  State<addNewMenuItem> createState() => _addNewMenuItemState();
}

class _addNewMenuItemState extends State<addNewMenuItem> {
  @override
  Widget build(BuildContext context) {
    return TextFormField();
  }

  void setNewItem(
    String name,
    double price,
  ) {
    Item t1 = Item(
        providerID: name,
        name: 'Burger',
        description: 'Describ....',
        originalPrice: 5.0,
        imageURL: '');
    Database db = Database();
    db.addToProviderMenu(t1);
  }
}
