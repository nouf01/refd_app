// ignore_for_file: prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/ConfirmOrder.dart';
import 'package:refd_app/Consumer_Screens/LoggedConsumer.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/Elements/path.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/DailyMenu_Item.dart';
import '../DataModel/Provider.dart';
import '../Elements/restaurantInfo.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreen();
}

class _CartScreen extends State<CartScreen> {
  Database DB = Database();
  Consumer? currentUser; //build consumer object here so its up to date
  Future<List<DailyMenu_Item>>? userCart;
  List<DailyMenu_Item>? cartItems;
  Provider? prov;
  double currentTotal = 0.0;
  List<int> currentQuantity = [];
  List<int> maxQuantity = [];
  int cartIsEmpty = -1; // means not intilized
  int numCartItems = 0;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? ref;
  LoggedConsumer log = LoggedConsumer();

  Future<void> _initRetrieval() async {
    currentUser = await log.buildConsumer();
    ref = DB.searchForConsumerStream(currentUser!.get_email());
    currentTotal = currentUser!.cartTotal;

    if (currentUser!.cartTotal > 0.001) {
      userCart = DB.retrieve_Cart_Items(currentUser!.get_email());
      cartItems = await DB.retrieve_Cart_Items(currentUser!.get_email());
      int i = 0;
      cartItems!.forEach((element) {
        currentQuantity.add(element.getChoosedCartQuantity);
        maxQuantity.add(element.get_quantity);
        i++;
      });
      prov = Provider.fromDocumentSnapshot(
          await DB.searchForProvider(cartItems![0].getItem().get_providerID));
      cartIsEmpty = 1; // means not empty
      numCartItems = currentUser!.numOfCartItems;
      print('*******************************************');
      print(numCartItems);
    } else {
      cartIsEmpty = 0;
    } //means empty
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }

  @override
  Widget build(BuildContext context) {
    /*while (cartIsEmpty == -1) {
      setState(() {});
      return Container(
        color: Colors.white,
        child: Center(
          child: ListView(
            children: const <Widget>[
              Align(
                  alignment: AlignmentDirectional.center,
                  child: const Center(child: CircularProgressIndicator())),
            ],
          ),
        ),
      );
    }
    if (cartIsEmpty == 0) {
      return Center(
        child: ListView(
          children: const <Widget>[
            Align(
                alignment: AlignmentDirectional.center,
                child: Text('cart is empty')),
          ],
        ),
      );
    } else {*/
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF89CDA7),
          title: Text('My Cart'),
          centerTitle: true,
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder(
            stream: ref,
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                    snapshot) {
              if (snapshot.data == null) {
                return CircularProgressIndicator();
              }
              int numCart = snapshot.data!.get('numOfCartItems');
              if (numCart > 0) {
                return SafeArea(
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              /*
                    restaurantInfo(
                      currentProve: prov!,
                    ),*/
                              Container(
                                height: 620,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: FutureBuilder(
                                    future: userCart,
                                    builder: (BuildContext context,
                                        AsyncSnapshot<List<DailyMenu_Item>>
                                            snapshot) {
                                      if (snapshot.hasData &&
                                          snapshot.data!.isNotEmpty &&
                                          cartItems != null) {
                                        return ListView.separated(
                                            separatorBuilder:
                                                (context, index) =>
                                                    const SizedBox(
                                                      height: 3,
                                                    ),
                                            itemCount: cartItems!.length,
                                            shrinkWrap: true,
                                            //padding: EdgeInsets.all(8),
                                            itemBuilder: (context, index) {
                                              return Card(
                                                elevation: 0,
                                                child: Container(
                                                  height: 100,
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  width: 100,
                                                  margin: EdgeInsets.all(4.0),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 60,
                                                        decoration:
                                                            BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  cartItems![
                                                                          index]
                                                                      .getItem()
                                                                      .get_imageURL())),
                                                        ),
                                                      ),
                                                      SizedBox(width: 16),
                                                      Expanded(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 16.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                cartItems![
                                                                        index]
                                                                    .getItem()
                                                                    .get_name(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                                softWrap: true,
                                                              ),
                                                              Text(
                                                                  "\$${cartItems![index].getItem().get_originalPrice().toStringAsFixed(2)}",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough,
                                                                  )),
                                                              Text(
                                                                  "${cartItems![index].getPriceAfetr_discount.toStringAsFixed(2)}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          16,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      color: Colors
                                                                          .red)),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text('Quantity',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          Row(
                                                            children: [
                                                              IconButton(
                                                                  iconSize: 10,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .remove,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    print(
                                                                        'quantity: ${currentQuantity[index]}');
                                                                    if (currentQuantity[
                                                                            index] !=
                                                                        0) {
                                                                      currentQuantity[
                                                                          index]--;
                                                                      currentTotal =
                                                                          currentTotal -
                                                                              cartItems![index].getPriceAfetr_discount;
                                                                      setState(
                                                                          () {});
                                                                      await DB.decermentQuantity(
                                                                          currentUser!
                                                                              .get_email(),
                                                                          cartItems![
                                                                              index]);
                                                                      if (currentQuantity[
                                                                              index] ==
                                                                          0) {
                                                                        cartItems!
                                                                            .remove(cartItems![index]);
                                                                        currentQuantity
                                                                            .remove(currentQuantity[index]);
                                                                        maxQuantity
                                                                            .remove(maxQuantity[index]);
                                                                      }
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  }),
                                                              Container(
                                                                // padding: EdgeInsets.all(8.0),
                                                                child: Text(
                                                                    currentQuantity[
                                                                            index]
                                                                        .toString()),
                                                              ),
                                                              IconButton(
                                                                  iconSize: 10,
                                                                  icon: Icon(
                                                                    Icons.add,
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    if (currentQuantity[
                                                                            index] <
                                                                        maxQuantity[
                                                                            index]) {
                                                                      setState(
                                                                          () {
                                                                        currentQuantity[
                                                                            index]++;
                                                                        currentTotal =
                                                                            currentTotal +
                                                                                cartItems![index].getPriceAfetr_discount;
                                                                      });
                                                                      await DB.incrementQuantity(
                                                                          currentUser!
                                                                              .get_email(),
                                                                          cartItems![
                                                                              index]);
                                                                    }
                                                                  }),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            });
                                      } else if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          cartItems!.isEmpty) {
                                        return Center(
                                          child: ListView(
                                            children: const <Widget>[
                                              Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  child: Text('cart is empty')),
                                            ],
                                          ),
                                        );
                                      } else {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      _buildBottom(),
                    ],
                  ),
                );
              } else if (numCart == 0) {
                return Column(
                  children: [
                    Image.asset('cart_empty.png'),
                    Text('Your Cart is empty!'),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }));
  }

  Positioned _buildBottom() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 16.0,
          right: 16,
          bottom: 8.0,
          top: 4.0,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Total:",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      currentTotal.toStringAsFixed(2),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    Text(
                      "Total is include VAT",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16.0,
                      ),
                      backgroundColor: Color(0xFF89CDA7),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      int cancelCount = currentUser!.get_cancelCounter();
                      if (cancelCount >= 10) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(
                                "You can't continue the order",
                              ),
                              content: Text(
                                  'You will not be able to continue the order because you reach NO Pick-Up limit, please contact the Techincal support for more information'),
                              actions: [
                                ElevatedButton(
                                  child: Text("OK"),
                                  style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF89CDA7),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => path(
                                      p: prov!,
                                    )));
                      }
                    },
                    child: Text("Continue"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
