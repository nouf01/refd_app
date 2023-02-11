// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/Elements/appText.dart';
import 'package:refd_app/Elements/itemCard.dart';
import 'package:refd_app/Provider_Screens/DailyMenu.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/ProviderNavigation.dart';

import '../DataModel/DB_Service.dart';
import '../DataModel/Provider.dart';
import '../DataModel/item.dart';
import 'AddNewItemToMenu.dart';

class SelectMenu extends StatefulWidget {
  @override
  _SelectMenuState createState() => _SelectMenuState();
}

class _SelectMenuState extends State<SelectMenu> {
  Database service = Database();
  LoggedProvider log = LoggedProvider();
  Future<List<Item>>? itemList;
  List<Item>? retrieveditemList;
  //
  List<bool> selectedFlag = [];

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    itemList = service.retrieveMenuItems(log.getEmailOnly());
    retrieveditemList = await service.retrieveMenuItems(log.getEmailOnly());
    for (int i = 0; i < retrieveditemList!.length; i++) {
      if (retrieveditemList![i].get_inDM() == 1) {
        retrieveditemList!.remove(retrieveditemList![i]);
        i = i - 1;
      }
    }
    retrieveditemList!.forEach((element) {
      selectedFlag.add(false);
    });
    setState(() {});
  }

  /*Future<void> _refresh() async {
    itemList = service.retrieveMenuItems(log.getEmailOnly());
    retrieveditemList = await service.retrieveMenuItems(log.getEmailOnly());
    retrieveditemList!.forEach((element) {
      selectedFlag.add(false);
    });
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose items to be added',
            style: TextStyle(
                color: Color(0xFF89CDA7),
                fontSize: 16,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('             Add to daily menu             '),
        onPressed: () async {
          for (int i = 0; i < retrieveditemList!.length; i++) {
            if (selectedFlag[i] == true) {
              var cureentItem = retrieveditemList![i];
              cureentItem.set_inDM(1);
              var d =
                  DailyMenu_Item(item: cureentItem, quantity: 1, discount: 0.1);
              service.addToProviderDM(d);
            }
          }
          List<DailyMenu_Item> list =
              await service.retrieve_DMmenu_Items(log.getEmailOnly());
          print('hhhhhhhhhhhhhhhhhhhhh ${list.length}');
          service.updateProviderInfo(log.getEmailOnly(), false, '',
              {'NumberOfItemsInDM': list.length});
          //show dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  "Your items added to daily menu successfuly",
                ),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF89CDA7),
                    ),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProviderNavigation(
                                    choosedIndex: 1,
                                  )));
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Color(0xFF89CDA7),
        foregroundColor: Colors.white,
        icon: Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: itemList,
          builder: (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.separated(
                  itemCount: retrieveditemList!.length,
                  separatorBuilder: (context, index) => const SizedBox(
                        height: 10,
                      ),
                  itemBuilder: (context, index) {
                    return itemCard(index);
                  });
              ;
            } else if (snapshot.connectionState == ConnectionState.done &&
                retrieveditemList!.isEmpty) {
              return Center(
                child: ListView(
                  children: const <Widget>[
                    Align(
                        alignment: AlignmentDirectional.center,
                        child: Text('No data available')),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildSelectIcon(bool isSelected, int index) {
    return Icon(
      isSelected ? Icons.check_box : Icons.check_box_outline_blank,
      color: Theme.of(context).primaryColor,
    );
  }

  Widget itemCard(int index) {
    bool isSelected = selectedFlag[index];
    return Container(
      width: 174,
      height: 150,
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xffE2E2E2),
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedFlag[index] = !isSelected;
          });
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSelectIcon(isSelected, index),
                  Image.network(
                    height: 70,
                    width: 70,
                    fit: BoxFit.contain,
                    retrieveditemList![index].get_imageURL(),
                  ),
                  SizedBox(width: 5),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 150,
                          child: Text(
                            retrieveditemList![index].get_name(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            softWrap: true,
                          )),
                      Container(
                        width: 150,
                        height: 60,
                        child: Text(
                          retrieveditemList![index].getDecription(),
                          maxLines: 5,
                          softWrap: true,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF7C7C7C),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "\$${retrieveditemList![index].get_originalPrice().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
