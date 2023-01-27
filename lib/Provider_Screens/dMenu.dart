import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:badges/badges.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class dMenu extends StatefulWidget {
  const dMenu({super.key});

  @override
  State<dMenu> createState() => _dMenu();
}

class _dMenu extends State<dMenu> {
  Database DB = Database();
  Provider? currentPro; //build consumer object here so its up to date
  Future<List<Item>>? items;
  List<Item>? menuItems;
  List<int> currentQuantity = [];
  Stream<DocumentSnapshot<Map<String, dynamic>>>? ref;

  Future<void> _initRetrieval() async {
    // ref = await DB.searchForProvider('Alromansiah@mail.com');
    currentPro = Provider.fromDocumentSnapshot(
        await DB.searchForProvider('herfy@gmail.com'));

    items = DB.retrieveMenuItems(currentPro!.get_email());
    menuItems = await DB.retrieveMenuItems('herfy@gmail.com');

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
        title: const Text("Daily Menu"),
        backgroundColor: Colors.green,
      ),


      body: SafeArea(
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
                      height: 450,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: FutureBuilder(
                          future: items,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Item>>
                              snapshot) {
                            if (snapshot.hasData &&
                                snapshot.data!.isNotEmpty) {
                              return ListView.separated(
                                  separatorBuilder:
                                      (context, index) =>
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  itemCount: menuItems!.length,
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
                                                        menuItems![
                                                        index]
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
                                                  children: [
                                                    Text(
                                                      menuItems![
                                                      index]
                                                          .get_name(),
                                                      maxLines: 1,
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style:
                                                      TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                      ),
                                                    ),
                                                   Text(
                                                      "${menuItems![index].get_originalPrice().toStringAsFixed(2)} SAR",
                                                      style:
                                                      TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            } else if (snapshot.connectionState ==
                                ConnectionState.done &&
                                menuItems!.isEmpty) {
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
          ],
        ),
      ),





























      /*
      body: Container(
        child: ListView.builder(
           itemCount: menuItems!.length,
            itemBuilder: (context, index){
              return Card(
                //height: 140,
                color: Colors.blue,
                child: Padding(
                  padding: EdgeInsets.all(14.0),
                  child: ListTile(
                    title: Text(menuItems![index].get_name()),
                  ),

                ),
              );
            },

        ),
      ),
*/ //new







      /*body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: 450,
                      child: Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: FutureBuilder(
                          future: items,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Item>> snapshot) {
                            /* if (snapshot.hasData &&
    snapshot.data!.isNotEmpty) {
      return ListView.separated(
        separatorBuilder:
            (context, index) =>
        const SizedBox(
          height: 3,
        ),
        itemCount: menuItems!.length,
        shrinkWrap: true,
        //padding: EdgeInsets.all(8),
          itemBuilder: (context, index){
            return Card();

          }
      );
    },*/

                            return ListView.separated(
                                separatorBuilder: (context, index) =>
                                    const SizedBox(
                                      height: 3,
                                    ),
                                itemCount: menuItems!.length,
                                shrinkWrap: true,
                                //padding: EdgeInsets.all(8),
                                itemBuilder: (context, index) {
                                  return Card(
                                    elevation: 0,
                                    child: Container(
                                      height: 100,
                                      padding: const EdgeInsets.all(8.0),
                                      width: 100,
                                      margin: EdgeInsets.all(4.0),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 60,
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      menuItems![index]
                                                          .get_imageURL())),
                                            ),
                                          ),
                                          SizedBox(width: 16),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    menuItems![index]
                                                        .get_name(),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "${menuItems![index].get_originalPrice().toStringAsFixed(2)} SAR",
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                  iconSize: 10,
                                                  icon: Icon(
                                                    Icons.remove,
                                                  ),
                                                  onPressed: () async {

                                                  }),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),*/ //saraaaaaaaa









      /*body: Stack(
        children: [
          Container(),
          Positioned.fill(
            child: StreamBuilder(
            stream: ref,
            builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData /*&& snapshot.data!.isNotEmpty*/) {},
            },
              ),
              ),
             ],
            ),*/
    );
  }
}

/*return Scaffold(
      body: Stack(
        children: [
          Container(),
          SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              //itemCount: cartController.cartItems.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) => Container(
                height: 100,
                width: 100,
                margin: EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Container(
                      width:100 ,
                      color: Colors.blue,
                    ),
                    Column(
                      children: [
                        Text("Titel"),
                        Text("descrption"),
                        Text("pricesssss"),


                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text("ADD"),
                ),
              ],
            ),
          ),
        ],
      ),
    ); //Scaffold
  }
}
*/
