import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/item.dart';
import 'package:refd_app/Elements/OrderCard.dart';

class listOfOrders extends StatefulWidget {
  final int status;
  final String provID;
  const listOfOrders({super.key, required this.status, required this.provID});

  @override
  State<listOfOrders> createState() => _listOfOrdersState();
}

class _listOfOrdersState extends State<listOfOrders> {
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
      body: Padding(
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
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16.0)),
                        child: OrderCard(order: o1));
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
    );
  }

  void _refresh() {
    OrderStatus myStatus = OrderStatus.underProcess; //intial value
    if (this.widget.status == 0) {
      myStatus = OrderStatus.underProcess;
    } else if (this.widget.status == 1) {
      myStatus = OrderStatus.waitingForPickUp;
    } else if (this.widget.status == 2) {
      myStatus = OrderStatus.pickedUp;
    }
    ref = service.retrieve_Some_Orders_Of_Prov(this.widget.provID, myStatus);
    setState(() {});
  }

  /*void _dismiss() {
    itemList = service.retrieveMenuItems('MacDonalds2008');
  }*/

  void _initRetrieval() {
    OrderStatus myStatus = OrderStatus.underProcess; //intial value
    if (this.widget.status == 0) {
      myStatus = OrderStatus.underProcess;
    } else if (this.widget.status == 1) {
      myStatus = OrderStatus.waitingForPickUp;
    } else if (this.widget.status == 2) {
      myStatus = OrderStatus.pickedUp;
    }
    ref = service.retrieve_Some_Orders_Of_Prov(this.widget.provID, myStatus);
  }

  void methodDoNothing() {}
}
