// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:refd_app/Elements/appText.dart';
import 'package:refd_app/Provider_Screens/EditItem.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';

class GroceryItemCardWidget extends StatelessWidget {
  GroceryItemCardWidget({Key? key, required this.item, this.heroSuffix})
      : super(key: key);
  final Item item;
  final String? heroSuffix;

  final double width = 174;
  final double height = 150;
  final Color borderColor = Color(0xffE2E2E2);
  final double borderRadius = 18;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(
          borderRadius,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              imageWidget(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    textAlign: TextAlign.start,
                    text: item.get_name(),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  Container(
                    width: 170,
                    height: 55,
                    child: Text(
                      'lore ipsuim hjter dhg slryfs hfsmf sgeyw djslw dgsjwnr sh fjwle shioryw ',
                      maxLines: 5,
                      softWrap: true,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF7C7C7C),
                      ),
                    ),
                  ),
                  AppText(
                    text: "\$${item.get_originalPrice().toStringAsFixed(2)}",
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
              editButton(context),
              deleteButton(context),
            ]),
          ],
        ),
      ),
    );
  }

  Widget imageWidget() {
    return Image.network(
      height: 100,
      width: 100,
      fit: BoxFit.contain,
      item.get_imageURL(),
    );
  }

  Widget editButton(context) {
    return Container(
      alignment: Alignment.centerRight,
      height: 30,
      width: 30,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(17)),
      child: Center(
        child: IconButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditScreen(
                          currentItem: item,
                        )));
          },
          icon: Icon(Icons.edit),
          color: Color(0xFF66CDAA),
          iconSize: 25,
        ),
      ),
    );
  }

  Widget deleteButton(context) {
    return Container(
      alignment: Alignment.centerRight,
      height: 30,
      width: 30,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(17)),
      child: Center(
        child: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Are you sure you want to delete this item",
                  ),
                  actions: [
                    ElevatedButton(
                      child: Text("OK"),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF66CDAA),
                      ),
                      onPressed: () {
                        Database db = Database();
                        db.removeFromPrvoiderMenu(item);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.delete),
          color: Color(0xFF66CDAA),
          iconSize: 25,
        ),
      ),
    );
  }
}
