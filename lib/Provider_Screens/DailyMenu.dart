import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/Consumer_Screens/itemDetail.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/Provider.dart';
import '../DataModel/item.dart';

class DailyMenuScreen extends StatefulWidget {
  const DailyMenuScreen({super.key});

  @override
  State<DailyMenuScreen> createState() => _DailyMenuScreenState();
}

class _DailyMenuScreenState extends State<DailyMenuScreen> {

  Database service = Database();
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
      appBar: AppBar(
        title: Center(child: Text('Daily Menu')),
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder(
            future: itemList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Item>> snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return ListView.separated(
                    itemCount: retrieveditemList!.length,
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      return Dismissible(
                        onDismissed: ((direction) async {
                          await service.removeFromPrvoiderMenu(
                              retrieveditemList![index]);
                          _dismiss();
                        }),
                        background: Container(
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(16.0)),
                          padding: const EdgeInsets.only(right: 28.0),
                          alignment: AlignmentDirectional.centerEnd,
                          child: const Text(
                            "DELETE",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        direction: DismissDirection.endToStart,
                        resizeDuration: const Duration(milliseconds: 200),
                        key: UniqueKey(),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0)),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/edit",
                                  arguments: retrieveditemList![index]);
                            },
                            leading: Image.network(
                                retrieveditemList![index].get_imageURL()),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            title: Text(retrieveditemList![index].get_name()),
                            subtitle: Text(
                                "${retrieveditemList![index].getDecription()}, ${retrieveditemList![index].get_originalPrice()}"),
                            trailing: const Icon(Icons.arrow_right_sharp),
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

    );
  }

  Future<void> _refresh() async {
    itemList = service.retrieveMenuItems('Dunkindonuts@mail.com');
    retrieveditemList = await service.retrieveMenuItems('Dunkindonuts@mail.com');
    setState(() {});
  }

  void _dismiss() {
    itemList = service.retrieveMenuItems('Dunkindonuts@mail.com');
  }

  Future<void> _initRetrieval() async {
    itemList = service.retrieveMenuItems('Dunkindonuts@mail.com');
    retrieveditemList = await service.retrieveMenuItems('Dunkindonuts@mail.com');
  }
}













/*
  Database DB = Database();
  Provider? currentPro; //build consumer object here so its up to date
  Future<List<Item>>? items;
  List<Item>? menuItems;
  List<int> currentQuantity = [];
  Stream<DocumentSnapshot<Map<String, dynamic>>>? ref;


  Future<void> _initRetrieval() async {
    // ref = await DB.searchForProvider('Alromansiah@mail.com');
    currentPro = Provider.fromDocumentSnapshot(
        await DB.searchForProvider('DrCafe@mail.com'));

    items = DB.retrieveMenuItems(currentPro!.get_email());
    menuItems = DB.retrieveMenuItems('DrCafe@mail.com') as List<Item>?;

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initRetrieval();
  }



  @override

  //final ref = FirebaseDatabase.instance.ref('');
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Daily Menu"),
        backgroundColor: Colors.green,
      ),

      body: Stack(
        children: [
          Container(),
             Positioned.fill(
              child: ListView.builder(
                shrinkWrap: true,
                  itemBuilder:
                  (context , index) => Container(height: 100,width:100 , color: Colors.purple, margin:EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(menuItems![index].get_imageURL()),
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

  */