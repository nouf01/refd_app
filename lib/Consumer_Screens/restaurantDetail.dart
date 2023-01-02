import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../DataModel/DB_Service.dart';
import '../DataModel/DailyMenu_Item.dart';
import '../DataModel/Provider.dart';
import '../Elements/itemDetail.dart';
import '../Elements/restaurantInfo.dart';

class restaurantDetail extends StatefulWidget {
  const restaurantDetail({super.key, required this.currentProv});
  final Provider currentProv;

  @override
  State<restaurantDetail> createState() => _restaurantDetail();
}

class _restaurantDetail extends State<restaurantDetail> {
  int successflAdd = 1;
  Database DB = Database();
  Future<List<DailyMenu_Item>>? itemList;
  List<DailyMenu_Item>? retrieveditemList;

  Future<void> _initRetrieval() async {
    itemList = DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
    retrieveditemList =
        await DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
  }

  Future<void> _refresh() async {
    itemList = DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
    retrieveditemList =
        await DB.retrieve_DMmenu_Items(this.widget.currentProv.get_email);
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
        title: Center(child: Text('Restaurant Details')),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          restaurantInfo(
            currentProve: this.widget.currentProv,
          ),
          Container(
            height: 520,
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
