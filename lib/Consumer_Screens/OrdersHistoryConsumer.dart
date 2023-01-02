import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/item.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
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
        title: Center(child: Text('My Orders')),
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
                      Order_object o1 = Order_object.fromDocumentSnapshot(
                          snapshot.data!.docs![index]);
                      return Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.0)),
                          child: ListTile(
                            leading: Image.network(o1.getProviderLogo),
                            isThreeLine: true,
                            onTap: () {
                              Navigator.pushNamed(context, "/edit",
                                  arguments: snapshot.data!.docs![index]);
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            title: Text('Order #${o1.getorderID}'),
                            subtitle: Text(
                                '${o1.get_ProviderID.toString().replaceAll('@mail.com', '')} \n ${o1.getdate.toString()}'),
                            trailing: Column(
                              children: [
                                SizedBox(height: 20),
                                Text(
                                    '${o1.get_status.toString().replaceAll('OrderStatus.', '')}'),
                              ],
                            ),
                          ));
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
    );
  }

  Future<void> _refresh() async {
    ref = service.retrieve_AllOrders_Of_Consumer('nouf888s@gmail.com');
    setState(() {});
  }

  /*void _dismiss() {
    itemList = service.retrieveMenuItems('MacDonalds2008');
  }*/

  Future<void> _initRetrieval() async {
    ref = service.retrieve_AllOrders_Of_Consumer('nouf888s@gmail.com');
  }

  void methodDoNothing() {}
}
