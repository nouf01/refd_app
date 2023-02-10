// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/Elements/appText.dart';
import 'package:refd_app/Elements/itemCard.dart';
import 'package:refd_app/Provider_Screens/EditItem.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';

import '../DataModel/DB_Service.dart';
import '../DataModel/Provider.dart';
import '../DataModel/item.dart';
import 'AddNewItemToMenu.dart';

class MenuScreen extends StatefulWidget {
  //final Provider currentProv;
  const MenuScreen({
    super.key,
    /*required this.currentProv*/
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Database service = Database();
  LoggedProvider log = LoggedProvider();
  Future<List<Item>>? itemList;
  List<Item>? retrieveditemList;

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: itemList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty ||
                  retrieveditemList != null) {
                return ListView.separated(
                    itemCount: retrieveditemList!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (context, index) {
                      return Container(
                        width: 174,
                        height: 170,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color(0xffE2E2E2),
                          ),
                          borderRadius: BorderRadius.circular(
                            18,
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
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    imageWidget(index),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            width: 150,
                                            child: Text(
                                              retrieveditemList![index]
                                                  .get_name(),
                                              style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                              softWrap: true,
                                            )),
                                        Container(
                                          width: 170,
                                          height: 60,
                                          child: Text(
                                            retrieveditemList![index]
                                                .getDecription(),
                                            maxLines: 5,
                                            softWrap: true,
                                            overflow: TextOverflow.fade,
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF7C7C7C),
                                            ),
                                          ),
                                        ),
                                        AppText(
                                          text:
                                              "${retrieveditemList![index].get_originalPrice().toStringAsFixed(2)}SR",
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    editButton(context, index),
                                    deleteButton(context, index),
                                  ]),
                            ],
                          ),
                        ),
                      );
                    });
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
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF66CDAA),
        onPressed: (() {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDish()));
        }),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _refresh() async {
    itemList = service.retrieveMenuItems(log.getEmailOnly());
    retrieveditemList = await service.retrieveMenuItems(log.getEmailOnly());
    setState(() {});
  }

  void _dismiss() {
    itemList = service.retrieveMenuItems(log.getEmailOnly());
  }

  Future<void> _initRetrieval() async {
    itemList = service.retrieveMenuItems(log.getEmailOnly());
    retrieveditemList = await service.retrieveMenuItems(log.getEmailOnly());
  }

  Widget imageWidget(int index) {
    return Image.network(
      height: 60,
      width: 60,
      fit: BoxFit.contain,
      retrieveditemList![index].get_imageURL(),
    );
  }

  Widget editButton(context, int index) {
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
                          currentItem: retrieveditemList![index],
                        )));
            _refresh();
          },
          icon: Icon(Icons.edit),
          color: Color(0xFF66CDAA),
          iconSize: 25,
        ),
      ),
    );
  }

  Widget deleteButton(context, int index) {
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
                      onPressed: () async {
                        Database db = Database();
                        Item t = retrieveditemList![index];
                        retrieveditemList!.remove(retrieveditemList![index]);
                        db.removeFromPrvoiderMenu(t);
                        DailyMenu_Item d = DailyMenu_Item.fromDocumentSnapshot(
                            await FirebaseFirestore.instance
                                .collection('Providers')
                                .doc(t.get_providerID)
                                .collection('DailyMenu')
                                .doc(t.getId())
                                .get());
                        db.removeFromPrvoiderDM(t.get_providerID, d);
                        _refresh();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.delete),
          color: Color.fromARGB(255, 205, 102, 102),
          iconSize: 25,
        ),
      ),
    );
  }
}
