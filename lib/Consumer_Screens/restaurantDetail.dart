// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/LoggedConsumer.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/DailyMenu_Item.dart';
import '../DataModel/Provider.dart';
import '../Elements/restaurantInfo.dart';
import 'CartScreen.dart';
import 'itemDetail.dart';

class restaurantDetail extends StatefulWidget {
  const restaurantDetail({super.key, required this.currentProv});
  final Provider currentProv;

  @override
  State<restaurantDetail> createState() => _restaurantDetail();
}

class _restaurantDetail extends State<restaurantDetail> {
  int successflAdd = 1;
  LoggedConsumer log = LoggedConsumer();
  Database DB = Database();
  Future<List<DailyMenu_Item>>? itemList;
  List<DailyMenu_Item>? retrieveditemList;
  Consumer? currentUser;
  bool cartIsEmpty = true;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? ref;

  Future<void> _initRetrieval() async {
    currentUser = await log.buildConsumer();
    ref = DB.searchForConsumerStream(currentUser!.get_email());
    itemList = DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
    retrieveditemList =
        await DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
    for (int i = 0; i < retrieveditemList!.length; i++) {
      if (retrieveditemList![i].get_quantity == 0) {
        retrieveditemList!.remove(retrieveditemList![i]);
        i = i - 1;
      }
    }
    setState(() {});
  }

  Future<void> _refresh() async {
    itemList = DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
    retrieveditemList =
        await DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
    for (int i = 0; i < retrieveditemList!.length; i++) {
      if (retrieveditemList![i].get_quantity() == 0) {
        retrieveditemList!.remove(retrieveditemList![i]);
        i = i - 1;
      }
    }
    setState(() {});
  }

  void _dismiss() {
    itemList = DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF66CDAA),
        title: Text(widget.currentProv.get_commercialName),
        centerTitle: true,
        actions: [
          StreamBuilder(
              stream: ref,
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                      snapshot) {
                if (snapshot.data == null) {
                  return CircularProgressIndicator();
                }
                int numCart = snapshot.data!.get('numOfCartItems');
                bool showB = false;
                if (numCart > 0) {
                  showB = true;
                }
                return Badge(
                  position: BadgePosition.topEnd(top: 3, end: 18),
                  showBadge: showB,
                  badgeContent: Text(numCart.toString(),
                      style: TextStyle(color: Colors.white)),
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      padding: EdgeInsets.only(right: 30.0),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CartScreen()),
                        );
                      }),
                );
              }),
        ],
      ),
      body: Column(
        children: [
          restaurantInfo(
            currentProve: widget.currentProv,
          ),
          Container(
            height: 600,
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder(
                  future: itemList,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DailyMenu_Item>> snapshot) {
                    if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                      return ListView.separated(
                          itemCount: retrieveditemList!.length,
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 10,
                              ),
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(16.0)),
                              child: Card(
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => items(
                                                currentItem: retrieveditemList![
                                                    index])));
                                  },
                                  leading: Image.network(
                                      retrieveditemList![index]
                                          .getItem()
                                          .get_imageURL()),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  title: Text(
                                    retrieveditemList![index]
                                        .getItem()
                                        .get_name(),
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      "${retrieveditemList![index].getItem().getDecription()}, \n ${retrieveditemList![index].getPriceAfetr_discount} SAR"),
                                  trailing: const Icon(Icons.arrow_right_sharp),
                                ),
                              ),
                            );
                          });
                    } else if (snapshot.connectionState ==
                            ConnectionState.done &&
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
          ),
        ],
      ),
    );
  }
}
