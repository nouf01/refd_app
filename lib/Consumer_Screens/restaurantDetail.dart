// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_geocoder/geocoder.dart';
import 'package:refd_app/Consumer_Screens/LoggedConsumer.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
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
  String? address = '      ';

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
    Coordinates coordinates = Coordinates(
        this.widget.currentProv.get_Lat, this.widget.currentProv.get_Lang);
    var addressRecived =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addressRecived.first;
    address = first.addressLine.toString();
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
        backgroundColor: Color(0xFF89CDA7),
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
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            restaurantInfo(
              currentProve: widget.currentProv,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                tileColor: Colors.white,
                leading: IconButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse(
                          'google.navigation:q=${this.widget.currentProv.get_Lat}, ${this.widget.currentProv!.get_Lang}&key=AIzaSyC02VeFbURsmFAN8jKyl_OhoqE0IMPSvQM'));
                    },
                    icon: Icon(
                      Icons.location_pin,
                      color: Color(0xFF89CDA7),
                    )),
                trailing: Container(
                    width: MediaQuery.of(context).size.width - 100.0,
                    child: Text(
                      '${address!}',
                      softWrap: true,
                    )),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Available Items',
                softWrap: true,
                maxLines: 7,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.start,
              ),
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
                      if (snapshot.hasData &&
                          snapshot.data!.isNotEmpty &&
                          snapshot.connectionState == ConnectionState.done) {
                        return SingleChildScrollView(
                          child: ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: retrieveditemList!.length,
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => items(
                                                currentItem: retrieveditemList![
                                                    index])));
                                  },
                                  child: Container(
                                      //width: 174,
                                      //height: 160,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0xffE2E2E2),
                                        ),
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 3,
                                          vertical: 15,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Image.network(
                                              height: 85,
                                              width: 85,
                                              fit: BoxFit.contain,
                                              retrieveditemList![index]
                                                  .getItem()
                                                  .get_imageURL(),
                                            ),
                                            SizedBox(width: 5),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    width: 150,
                                                    child: Text(
                                                      retrieveditemList![index]
                                                          .getItem()
                                                          .get_name(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                      softWrap: true,
                                                    )),
                                                Container(
                                                  width: 150,
                                                  height: 55,
                                                  child: Text(
                                                    retrieveditemList![index]
                                                        .getItem()
                                                        .getDecription(),
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
                                            Column(
                                              children: [
                                                Text(
                                                    "\$${retrieveditemList![index].getItem().get_originalPrice().toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                    )),
                                                Text(
                                                    '${retrieveditemList![index].getPriceAfetr_discount.toStringAsFixed(2)}',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.red)),
                                              ],
                                            ),
                                          ],
                                        ),
                                      )),
                                );
                              }),
                        );
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
      ),
    );
  }

  goToDetailsPage(int theIndex) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                items(currentItem: retrieveditemList![theIndex])));
  }
}
