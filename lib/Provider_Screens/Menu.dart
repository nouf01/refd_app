import 'package:flutter/material.dart';

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
        title: Center(child: Text('Menu')),
        backgroundColor: Color(0xFF66CDAA),
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
    itemList = service.retrieveMenuItems('MunchBakery@mail.com');
    retrieveditemList = await service.retrieveMenuItems('MunchBakery@mail.com');
    setState(() {});
  }

  void _dismiss() {
    itemList = service.retrieveMenuItems('MunchBakery@mail.com');
  }

  Future<void> _initRetrieval() async {
    itemList = service.retrieveMenuItems('MunchBakery@mail.com');
    retrieveditemList = await service.retrieveMenuItems('MunchBakery@mail.com');
  }
}
