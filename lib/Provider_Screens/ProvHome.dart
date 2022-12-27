import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/item.dart';

class HomeScreenProvider extends StatefulWidget {
  const HomeScreenProvider({super.key});

  @override
  State<HomeScreenProvider> createState() => _HomeScreenProviderState();
}

class _HomeScreenProviderState extends State<HomeScreenProvider> {
  Database service = Database();
  Stream<QuerySnapshot<Map<String, dynamic>>>? ref;

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
        backgroundColor: Colors.green,
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: StreamBuilder(
            stream: ref,
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData /*&& snapshot.data!.isNotEmpty*/) {
                return ListView.separated(
                    itemCount: snapshot.data!.docs.length,
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 10,
                        ),
                    itemBuilder: (context, index) {
                      return Dismissible(
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
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(16.0)),
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(context, "/edit",
                                  arguments: snapshot.data!.docs![index]);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            title: Text(
                                snapshot.data!.docs![index].data()['orderID']),
                            subtitle: Text(
                                "${snapshot.data!.docs![index].data()['total']}, ${snapshot.data!.docs![index].data()['providerID']}"),
                            trailing: const Icon(Icons.arrow_right_sharp),
                          ),
                        ),
                      );
                    });
              } else if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data!.docs.isEmpty) {
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
        backgroundColor: Colors.green,
        onPressed: (() {
          Navigator.pushNamed(context, '/add');
        }),
        tooltip: 'add',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _refresh() async {
    ref = service.retrieve_AllOrders_Of_Prov('PizzanIn2022');
    setState(() {});
  }

  /*void _dismiss() {
    itemList = service.retrieveMenuItems('MacDonalds2008');
  }*/

  Future<void> _initRetrieval() async {
    Order_object o1 = Order_object(
        date: DateTime.now(),
        total: 4.1,
        providerID: 'DrCafe',
        consumerID: 'sara@mail.com',
        status: OrderStatus.waitingForPickUp);
    service.addNewOrderToFirebase(o1);
    ref = service.retrieve_AllOrders_Of_Prov('PizzanIn2022');
  }

  void methodDoNothing() {}
}
