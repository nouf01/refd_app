import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../DataModel/DB_Service.dart';
import '../DataModel/DailyMenu_Item.dart';
import '../DataModel/Provider.dart';
import '../Elements/itemDetail.dart';
import '../Elements/restaurantInfo.dart';

// class CartScreen extends StatefulWidget {
//   const CartScreen({super.key});

//   @override
//   State<CartScreen> createState() => _CartScreenState();
// }

// class _CartScreenState extends State<CartScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Cart();
//   }
// }

class CartScreen extends StatefulWidget {
  const CartScreen({
    super.key,
  });

  @override
  State<CartScreen> createState() => _Cart();
}

class _Cart extends State<CartScreen> {
  int successflAdd = 1;
  Database DB = Database();
  Future<List<DailyMenu_Item>>? itemList;
  List<DailyMenu_Item>? retrieveditemList;
  late List<Provider> p;
  int num = 1;
  late String msg;

  Future<void> _initRetrieval() async {
    p = await DB.retrieveAllProviders();
    itemList = DB.retrieve_DMmenu_Items(p[0].get_email);
    retrieveditemList = await DB.retrieve_DMmenu_Items(p[0].get_email);
    if (num == 1) {
      msg =
          "your order placed sucessfully , \n you can track it in the order history screen";
    } else {
      msg =
          "placing the order failed! You exceed the number of canceled orders";
    }
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
        title: Center(child: Text('Restaurant Details')),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            restaurantInfo(
              currentProve: p[0],
            ),
            Container(
              height: 450,
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
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "3" +
                                                    " x " +
                                                    retrieveditemList![index]
                                                        .getItem()
                                                        .get_name(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  retrieveditemList![index]
                                                      .getItem()
                                                      .getDecription(),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text(
                                            (retrieveditemList![index]
                                                        .getPriceAfetr_discount
                                                        .toString())
                                                    .toString() +
                                                " SAR",
                                            style: TextStyle(
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ));
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(200, 35),
                  //padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                  backgroundColor: Colors.green,
                  //primary: Theme.of(context).accentColor,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        msg,
                      ),
                      content: Text(
                        " you can track it in the order history screen",
                      ),
                      actions: [
                        ElevatedButton(
                          child: Text("OK"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.green,
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 30, vertical: 30),
                          ),
                          onPressed: () {
                            ////////////
                            ////////////
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                ),
                //  showToast,
                child: Text("Place order"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
