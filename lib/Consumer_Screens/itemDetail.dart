// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/Consumer_Screens/LoggedConsumer.dart';
import 'package:refd_app/Consumer_Screens/restaurantDetail.dart';
import 'package:refd_app/Consumer_Screens/uiKit/libUI/theme/colors.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';

import '../DataModel/DB_Service.dart';
import '../DataModel/Provider.dart';

class items extends StatefulWidget {
  final DailyMenu_Item currentItem;
  const items({super.key, required this.currentItem});

  @override
  State<items> createState() => _items();
}

class _items extends State<items> {
  LoggedConsumer log = LoggedConsumer();
  int currentChoosedQuantity = 0;
  late int maximumQuantity; //can not choose more than that
  late List<DailyMenu_Item> userCart;
  late Consumer? currentUser;
  Database db = Database();
  bool cartIsEmpty = true;
  int numCartItems = 0;
  Stream<DocumentSnapshot<Map<String, dynamic>>>? ref;
  //Provider? prov;

  void _initRetrieval() async {
    currentUser = await log.buildConsumer();
    ref = db.searchForConsumerStream(currentUser!.get_email());
    maximumQuantity = widget.currentItem.get_quantity;
    if (currentUser!.cartTotal > 0.001) {
      cartIsEmpty = false;
      numCartItems = currentUser!.numOfCartItems;
    }
    setState(() {});
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
        title: Text(widget.currentItem.getItem().get_name()),
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
      body: CustomScrollView(
        slivers: <Widget>[
          itemAppBar(widget: widget),
          SliverToBoxAdapter(
            child: Column(
              children: [
                // Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: Text(
                //     textAlign: TextAlign.center,
                //     this.widget.currentItem.getItem().get_name(),
                //     style: TextStyle(
                //       color: Color(0xFF89CDA7),
                //       fontSize: 20,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 25, bottom: 10, top: 10),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 100,
                                child: Text(
                                  widget.currentItem.getItem().get_name(),
                                  softWrap: true,
                                  maxLines: 7,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 25, bottom: 8.0),
                                child: Container(
                                  height: 40,
                                  child: Container(
                                    height: 50,
                                    width: 350,
                                    child: Text(
                                      widget.currentItem
                                          .getItem()
                                          .getDecription(),
                                      maxLines: 7,
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            VerticalDivider(
                              color: black,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, bottom: 8),
                              child: Text(
                                "Quantity : " +
                                    (widget.currentItem.get_quantity
                                        .toString()) +
                                    " Available",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, bottom: 8),
                              child: Text(
                                "Discount percentage : " +
                                    (100 -
                                            widget.currentItem.get_discount *
                                                100)
                                        .toString() +
                                    "%",
                                style: const TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25.0, bottom: 8),
                              child: Text(
                                "Original price : " +
                                    (widget.currentItem
                                            .getItem()
                                            .get_originalPrice())
                                        .toString() +
                                    " SAR",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Discounted Price :  ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            widget.currentItem.getPriceAfetr_discount
                                    .toStringAsFixed(2) +
                                " SAR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(200, 35),
                              //padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
                              backgroundColor: Color(0xFF89CDA7),
                              //primary: Theme.of(context).accentColor,
                            ),
                            onPressed: () {
                              if (currentChoosedQuantity > 0) {
                                addToCart();
                              }
                            },
                            //  showToast,
                            child: Text("Add to cart"),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: Icon(
                              Icons.add,
                            ),
                            onPressed: () => incrementQuantity(),
                          ),
                          Container(
                            width: 16,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.6,
                              ),
                            ),
                            child: Text(
                              currentChoosedQuantity.toString(),
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: Icon(
                              Icons.remove,
                            ),
                            onPressed: () => decrementQuantity(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void incrementQuantity() {
    if (currentChoosedQuantity < maximumQuantity) {
      setState(() {
        currentChoosedQuantity++;
      });
    }
  }

  void decrementQuantity() {
    if (currentChoosedQuantity != 0) {
      setState(() {
        currentChoosedQuantity--;
      });
    }
  }

  void addToCart() async {
    List<DailyMenu_Item> userCart =
        await db.retrieve_Cart_Items(currentUser!.get_email());
    if (userCart.isEmpty == false) {
      if (userCart[0].getItem().get_providerID !=
          widget.currentItem.getItem().get_providerID) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text(
                      "You have previous order in the cart from a different store!"),
                  content: Text("Do you want to discard the previous order?"),
                  actions: [
                    ElevatedButton(
                        child: Text("Yes Delete"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 175, 91, 76),
                        ),
                        onPressed: () async {
                          db.emptyTheCart(currentUser!.get_email());
                          Navigator.of(context).pop();
                        }),
                    ElevatedButton(
                        child: Text("No"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 108, 114, 108),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]);
            });
      } else {
        // same provider
        bool searchResult = (await db.isItemInCart(
            widget.currentItem, currentUser!.get_email()));
        if (searchResult == true) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    title: Text("The Item is already in the cart !"),
                    actions: [
                      ElevatedButton(
                          child: Text("OK"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF89CDA7),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ]);
              });
        } else if (searchResult == false) {
          numCartItems = numCartItems + currentChoosedQuantity;
          setState(() {});
          DailyMenu_Item newItemToCart = widget.currentItem;
          newItemToCart.setChoosedCartQuantity(currentChoosedQuantity);
          db.addToCart_DMitems(currentUser!.get_email(), newItemToCart);
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("your items have been added to cart successflly!"),
                // content: Text("The old items have removed"),
                actions: [
                  ElevatedButton(
                    child: Text("OK"),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF89CDA7),
                      //   padding: EdgeInsets.symmetric(
                      //       horizontal: 30, vertical: 30),
                    ),
                    onPressed: () {
                      // MaterialPageRoute(
                      //   builder: (_) => cart_page(3),
                      // );

                      //////////////////
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      }
    } else {
      // cart is empty
      bool searchResult =
          (await db.isItemInCart(widget.currentItem, currentUser!.get_email()));
      if (searchResult == true) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("The Item is already in the cart !"),
                  actions: [
                    ElevatedButton(
                        child: Text("OK"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF89CDA7),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ]);
            });
      } else if (searchResult == false) {
        numCartItems = numCartItems + currentChoosedQuantity;
        setState(() {});
        DailyMenu_Item newItemToCart = widget.currentItem;
        newItemToCart.setChoosedCartQuantity(currentChoosedQuantity);
        db.addToCart_DMitems(currentUser!.get_email(), newItemToCart);
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("your items have been added to cart successflly!"),
              // content: Text("The old items have removed"),
              actions: [
                ElevatedButton(
                  child: Text("OK"),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF89CDA7),
                    //   padding: EdgeInsets.symmetric(
                    //       horizontal: 30, vertical: 30),
                  ),
                  onPressed: () {
                    // MaterialPageRoute(
                    //   builder: (_) => cart_page(3),
                    // );

                    //////////////////
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
  }
}

class itemAppBar extends StatelessWidget {
  const itemAppBar({
    Key? key,
    required this.widget,
  }) : super(key: key);

  final items widget;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFF89CDA7),
      pinned: true,
      expandedHeight: 250.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        background: Image.network(
          widget.currentItem.getItem().get_imageURL(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
