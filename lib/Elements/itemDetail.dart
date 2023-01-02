import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/Consumer_Screens/CartScreen.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';

import '../DataModel/Provider.dart';

class items extends StatefulWidget {
  final DailyMenu_Item currentItem;
  const items({super.key, required this.currentItem});

  @override
  State<items> createState() => _items();
}

class _items extends State<items> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                //       color: Colors.green,
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
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                this
                                    .widget
                                    .currentItem
                                    .getItem()
                                    .getDecription(),
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Discount percentage : " +
                                    (100 -
                                            this
                                                    .widget
                                                    .currentItem
                                                    .get_discount *
                                                100)
                                        .toString() +
                                    "%",
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Original price : " +
                                    (this
                                            .widget
                                            .currentItem
                                            .getItem()
                                            .get_originalPrice())
                                        .toString() +
                                    " SAR",
                                style: TextStyle(
                                  fontSize: 15,
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
                            "Price :  ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            this
                                    .widget
                                    .currentItem
                                    .getPriceAfetr_discount
                                    .toString() +
                                " SAR",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
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
                              backgroundColor: Colors.green,
                              //primary: Theme.of(context).accentColor,
                            ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      "your items have been added to cart successflly!"),
                                  // content: Text("The old items have removed"),
                                  actions: [
                                    ElevatedButton(
                                      child: Text("OK"),
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
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
                            ),
                            //  showToast,
                            child: Text("Add to cart"),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: Icon(
                              Icons.add,
                            ),
                            onPressed: () => null,
                          ),
                          Container(
                            width: 16,
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 0.6,
                              ),
                            ),
                            child: Text(
                              "0",
                              style: TextStyle(fontSize: 16),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            iconSize: 20,
                            icon: Icon(
                              Icons.remove,
                            ),
                            onPressed: () => null,
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
      backgroundColor: Colors.green,
      pinned: true,
      expandedHeight: 250.0,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            this.widget.currentItem.getItem().get_name(),
            textAlign: TextAlign.center,
            style: TextStyle(
              backgroundColor: Color.fromARGB(133, 254, 255, 254),
              color: Colors.green,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        background: Image.network(
          this.widget.currentItem.getItem().get_imageURL(),
          fit: BoxFit.cover,
        ),
      ),
      leading: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        onPressed: () => Navigator.of(context).pop(),
        child: Icon(
          Icons.arrow_back_ios,
          color: Colors.green,
        ),
      ),
    );
  }
}
