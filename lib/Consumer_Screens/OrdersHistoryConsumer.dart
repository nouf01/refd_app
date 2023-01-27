import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/Consumer_Screens/LoggedConsumer.dart';
import 'package:refd_app/Consumer_Screens/track.dart';
import 'package:refd_app/Consumer_Screens/trackCancelled.dart';
import 'package:refd_app/Consumer_Screens/trackUnderProcess.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/item.dart';

import '../Provider_Screens/ManageOrders.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  Database service = Database();
  LoggedConsumer log = LoggedConsumer();
  Stream<QuerySnapshot<Map<String, dynamic>>>? ref;
  Provider? thisOrderProvider;

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
        backgroundColor: Color(0xFF66CDAA),
        automaticallyImplyLeading: false,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        trackOrder(order: o1)),
                              );
                            },
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            title: Text('Order #${o1.getorderID}'),
                            subtitle: Text(
                                '${o1.getProviderName} \n ${o1.getdate.toString().substring(0, 16)}'),
                            trailing: Column(
                              children: [
                                SizedBox(height: 20),
                                getTheStatus(o1.get_status
                                    .toString()
                                    .replaceAll('OrderStatus.', '')),
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
    ref = service.retrieve_AllOrders_Of_Consumer(log.getEmailOnly());
    setState(() {});
  }

  /*void _dismiss() {
    itemList = service.retrieveMenuItems('MacDonalds2008');
  }*/

  Future<void> _initRetrieval() async {
    ref = service.retrieve_AllOrders_Of_Consumer(log.getEmailOnly());
  }

  Widget getTheStatus(String status) {
    if (status == 'underProcess') {
      return const Text(
        'Under Process',
        style: TextStyle(color: Colors.blue, fontSize: 10),
      );
    } else if (status == 'waitingForPickUp') {
      return const Text(
        'Waiting for pick up',
        style:
            TextStyle(color: Color.fromARGB(255, 202, 156, 41), fontSize: 10),
      );
    } else if (status == 'pickedUp') {
      return const Text(
        'Picked Up',
        style: TextStyle(color: Color(0xFF66CDAA), fontSize: 10),
      );
    } else if (status == 'canceled') {
      return const Text(
        'Canceled',
        style: TextStyle(color: Colors.red, fontSize: 10),
      );
    } else {
      return const Text(
        'No Status',
        style: TextStyle(color: Colors.grey, fontSize: 10),
      );
    }
  }
}
