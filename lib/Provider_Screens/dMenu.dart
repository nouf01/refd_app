import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/itemDetail.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/Elements/appText.dart';
import 'package:refd_app/Provider_Screens/LoggedProv.dart';
import 'package:refd_app/Provider_Screens/selectMenu.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/Provider.dart';
import '../DataModel/item.dart';

class DailyMenuWidget extends StatefulWidget {
  const DailyMenuWidget({super.key});

  @override
  State<DailyMenuWidget> createState() => _DailyMenuWidgetState();
}

class _DailyMenuWidgetState extends State<DailyMenuWidget> {
  Database service = Database();
  LoggedProvider log = LoggedProvider();
  Future<List<DailyMenu_Item>>? itemList;
  List<DailyMenu_Item>? retrieveditemList;
  List<int> currentQuantity = [];
  List<double> currentDiscount = []; // Option 2
  List<double> currentPrice = [];
  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Wrap(
        //will break to another line on overflow
        direction: Axis.horizontal, //use vertical to show  on vertical axis
        children: <Widget>[
          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton.extended(
                label: Text('             Save Updates             '),
                onPressed: () {
                  for (int i = 0; i < retrieveditemList!.length; i++) {
                    service.update_DM_Item_Info(
                        log.getEmailOnly(), retrieveditemList![i].get_uid, {
                      'quantity': currentQuantity[i],
                      'discount': currentDiscount[i] / 100,
                      'priceAfterDiscount': retrieveditemList![i]
                              .getItem()
                              .get_originalPrice() -
                          (retrieveditemList![i].getItem().get_originalPrice() *
                              currentDiscount[i] /
                              100),
                    });
                  }
                  //show dialog
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text(
                          "Your updates on daily menu was saved successfuly",
                        ),
                        actions: [
                          ElevatedButton(
                            child: Text("OK"),
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF66CDAA),
                            ),
                            onPressed: () {
                              _refresh();
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                backgroundColor: Color(0xFF66CDAA),
                foregroundColor: Colors.white,
                icon: Icon(
                  Icons.save,
                  color: Colors.white,
                ),
              )), //button first

          Container(
              margin: EdgeInsets.all(10),
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return bottomSelect();
                    },
                    enableDrag: true,
                    isScrollControlled: true,
                  );
                },
                backgroundColor: Color(0xFF66CDAA),
                child: Icon(Icons.add),
              )), // button second
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FutureBuilder(
                future: itemList,
                builder: (BuildContext context,
                    AsyncSnapshot<List<DailyMenu_Item>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return Column(
                      children: [
                        ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            // itemCount: retrieveditemList!.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 10,
                                ),
                            itemCount: retrieveditemList!.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
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
                                      horizontal: 15,
                                      vertical: 15,
                                    ),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Image.network(
                                                height: 70,
                                                width: 70,
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
                                                  AppText(
                                                    textAlign: TextAlign.start,
                                                    text: retrieveditemList![
                                                            index]
                                                        .getItem()
                                                        .get_name(),
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                  Container(
                                                    width: 150,
                                                    height: 55,
                                                    child: Text(
                                                      'lore ipsuim hjter dhg slryfs hfsmf sgeyw djslw dgsjwnr sh fjwle shioryw ',
                                                      maxLines: 5,
                                                      softWrap: true,
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color:
                                                            Color(0xFF7C7C7C),
                                                      ),
                                                    ),
                                                  ),
                                                  Text(
                                                      "\$${retrieveditemList![index].getItem().get_originalPrice().toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                      )),
                                                  Text(
                                                      "${currentPrice[index].toStringAsFixed(2)}",
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.red)),
                                                ],
                                              ),
                                              Column(children: [
                                                AppText(
                                                  text: "Quantity",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        iconSize: 10,
                                                        icon: Icon(
                                                          Icons.remove,
                                                        ),
                                                        onPressed: () async {
                                                          if (currentQuantity[
                                                                  index] !=
                                                              0) {
                                                            currentQuantity[
                                                                index]--;
                                                            setState(() {});
                                                            if (currentQuantity[
                                                                    index] ==
                                                                0) {
                                                              service.removeFromPrvoiderDM(
                                                                  log
                                                                      .getEmailOnly(),
                                                                  retrieveditemList![
                                                                      index]);
                                                              retrieveditemList!
                                                                  .remove(
                                                                      retrieveditemList![
                                                                          index]);
                                                              currentQuantity.remove(
                                                                  currentQuantity[
                                                                      index]);
                                                            }
                                                            setState(() {});
                                                          }
                                                        }),
                                                    Container(
                                                      // padding: EdgeInsets.all(8.0),
                                                      child: Text(
                                                          currentQuantity[index]
                                                              .toString()),
                                                    ),
                                                    IconButton(
                                                        iconSize: 10,
                                                        icon: Icon(
                                                          Icons.add,
                                                        ),
                                                        onPressed: () async {
                                                          setState(() {
                                                            currentQuantity[
                                                                index]++;
                                                          });
                                                        }),
                                                  ],
                                                ),
                                                AppText(
                                                  text: "Discount",
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                Row(
                                                  children: [
                                                    IconButton(
                                                        iconSize: 10,
                                                        icon: Icon(
                                                          Icons.remove,
                                                        ),
                                                        onPressed: () {
                                                          if (currentDiscount[
                                                                  index] !=
                                                              0) {
                                                            currentDiscount[
                                                                    index] =
                                                                currentDiscount[
                                                                        index] -
                                                                    10;
                                                            currentPrice[
                                                                index] = retrieveditemList![
                                                                        index]!
                                                                    .getItem()
                                                                    .get_originalPrice() -
                                                                (retrieveditemList![
                                                                            index]!
                                                                        .getItem()
                                                                        .get_originalPrice() *
                                                                    (currentDiscount[
                                                                            index] /
                                                                        100));
                                                            setState(() {});
                                                            if (currentDiscount[
                                                                    index] ==
                                                                0) {
                                                              //show dialog
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return AlertDialog(
                                                                    title:
                                                                        const Text(
                                                                      "Discount can not be zero",
                                                                    ),
                                                                    actions: [
                                                                      ElevatedButton(
                                                                        child: Text(
                                                                            "OK"),
                                                                        style: ElevatedButton
                                                                            .styleFrom(
                                                                          primary:
                                                                              Color(0xFF66CDAA),
                                                                        ),
                                                                        onPressed:
                                                                            () {
                                                                          currentDiscount[index] =
                                                                              10.0;
                                                                          setState(
                                                                              () {});
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                      ),
                                                                    ],
                                                                  );
                                                                },
                                                              );
                                                            }
                                                          }
                                                        }),
                                                    Container(
                                                      // padding: EdgeInsets.all(8.0),
                                                      child: currentDiscount[
                                                                  index] >
                                                              91.0
                                                          ? Text(
                                                              '100%',
                                                              style: TextStyle(
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Colors
                                                                      .green),
                                                            )
                                                          : Text(currentDiscount[
                                                                      index]
                                                                  .toString()
                                                                  .substring(
                                                                      0, 2) +
                                                              '%'),
                                                    ),
                                                    IconButton(
                                                        iconSize: 10,
                                                        icon: Icon(
                                                          Icons.add,
                                                        ),
                                                        onPressed: () {
                                                          if (currentDiscount[
                                                                  index] !=
                                                              100.0) {
                                                            setState(() {
                                                              currentDiscount[
                                                                      index] =
                                                                  currentDiscount[
                                                                          index] +
                                                                      10;
                                                              currentPrice[
                                                                  index] = retrieveditemList![
                                                                          index]!
                                                                      .getItem()
                                                                      .get_originalPrice() -
                                                                  (retrieveditemList![
                                                                              index]!
                                                                          .getItem()
                                                                          .get_originalPrice() *
                                                                      (currentDiscount[
                                                                              index] /
                                                                          100));
                                                            });
                                                          }
                                                        }),
                                                  ],
                                                ),
                                              ]),
                                            ],
                                          ),
                                        ]),
                                  ));
                            }),
                        SizedBox(
                          height: 70,
                        )
                      ],
                    );
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    itemList = service.retrieve_DMmenu_Items(log.getEmailOnly());
    retrieveditemList = await service.retrieve_DMmenu_Items(log.getEmailOnly());
    retrieveditemList!.forEach((element) {
      currentQuantity.add(element!.get_quantity);
    });
    retrieveditemList!.forEach((element) {
      currentDiscount.add(element.get_discount * 100);
    });
    setState(() {});
  }

  Future<void> _initRetrieval() async {
    itemList = service.retrieve_DMmenu_Items(log.getEmailOnly());
    retrieveditemList = await service.retrieve_DMmenu_Items(log.getEmailOnly());
    retrieveditemList!.forEach((element) {
      currentQuantity.add(element!.get_quantity);
    });
    retrieveditemList!.forEach((element) {
      currentDiscount.add(element.get_discount * 100);
    });
    retrieveditemList!.forEach((element) {
      currentPrice.add(element.getPriceAfetr_discount);
    });
  }

  Widget bottomSelect() {
    return Container(height: 600, child: SelectMenu());
  }
}
