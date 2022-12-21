import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'DailyMenu_Item.dart';
import 'Provider.dart';
import 'Order.dart';
import 'item.dart';

class Database {
  Database();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //************************ Provider **********************/
  addNewProviderToFirebase(Provider provider) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(provider.username)
        .set(provider.toMap());
  }

  void updateProviderInfo(
      String providerID, Map<String, dynamic> field_value_map) {
    //Done tested
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(providerID)
        .update(field_value_map);
  }

  void setAccountStatus(String provID, Status status) {
    //done tested
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(provID)
        .update({'accountStatus': status.toString().replaceAll('Status.', '')});
  }

  void addToProviderTags(String provId, List<Tags> listOfTags) {
    //Done Tested
    List<String> tags = [];
    listOfTags.forEach((e) {
      tags.add(e.toString().replaceAll('Tags.', ''));
    });
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(provId)
        .update({'tags': FieldValue.arrayUnion(tags)});
  }

  Future<List<String>> getProviderTags(String provID) async {
    //Done tested
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Providers").doc(provID).get();
    return snapshot.data()!["tags"].cast<String>();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> searchForProvider(
      //Done tested
      String providerID) async {
    return await FirebaseFirestore.instance
        .collection('Providers')
        .doc(providerID)
        .get();
  }

  Future<List<Provider>> retrieveAllProviders() async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Providers").get();
    return snapshot.docs
        .map((docSnapshot) => Provider.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  //************************ Menu **********************/

  void addToProviderMenu(Item newItem) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(newItem.getProviderID)
        .collection('itemsList')
        .doc(newItem.getName() + newItem.getProviderID)
        .set(newItem.toMap());
  }

  void removeFromPrvoiderMenu(Item newItem) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(newItem.getProviderID)
        .collection('itemsList')
        .doc(newItem.getName() + newItem.getProviderID)
        .delete();
  }

  void updateItemInfo(Item item, Map<String, dynamic> field_value_map) {
    //Done tested
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(item.getProviderID)
        .collection('itemsList')
        .doc(item.uid)
        .update(field_value_map);
  }

  Future<List<Item>> retrieveMenuItems(String provID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Providers")
        .doc(provID)
        .collection('itemsList')
        .get();
    return snapshot.docs
        .map((docSnapshot) => Item.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  //************************Daily Menu **********************/
  void addToProviderDM(DailyMenu_Item DM_Item) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(DM_Item.getItem().getProviderID)
        .collection('DailyMenu')
        .doc(DM_Item.getUid)
        .set(DM_Item.toMap());
    int ref = (await _db
            .collection('Providers')
            .doc(DM_Item.getItem().getProviderID)
            .get())
        .data()!['NumberOfItemsInDM'];
    ref = ref + 1;
    updateProviderInfo(
        DM_Item.getItem().getProviderID, {'NumberOfItemsInDM': ref});
  }

  void removeFromPrvoiderDM(String providerID, String itemID) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(providerID)
        .collection('DailyMenu')
        .doc(itemID)
        .delete();
    int ref = (await _db.collection('Providers').doc(providerID).get())
        .data()!['NumberOfItemsInDM'];
    ref = ref - 1;
    updateProviderInfo(providerID, {'NumberOfItemsInDM': ref});
  }

  void update_DM_Item_Info(String providerID, String dmItemID,
      Map<String, dynamic> field_value_map) {
    //Done tested
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(providerID)
        .collection('DailyMenu')
        .doc(dmItemID)
        .update(field_value_map);
  }

  Future<List<DailyMenu_Item>> retrieve_DMmenu_Items(String provID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Providers")
        .doc(provID)
        .collection('DailyMenu')
        .get();
    return snapshot.docs
        .map((docSnapshot) => DailyMenu_Item.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  //*************************Consumer *****************************/
  addNewConsumerToFirebase(Consumer consumer) async {
    //Done Tested
    await _db
        .collection('Consumers')
        .doc(consumer.getEmail())
        .set(consumer.toMap());
  }

  void updateConsumerInfo(
      String consumersID, Map<String, dynamic> field_value_map) {
    //Done tested
    FirebaseFirestore.instance
        .collection('Consumers')
        .doc(consumersID)
        .update(field_value_map);
  }

  void updateCancelCounter(String consumerID, bool plusOrMinus) async {
    //Done tested
    int ref = (await _db.collection('Consumers').doc(consumerID).get())
        .data()!['cancelCounter'];
    if (plusOrMinus == true) {
      ref = ref + 1;
    } else {
      ref = ref - 1;
    }
    updateConsumerInfo(consumerID, {'cancelCounter': ref});
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> searchForConsumer(
      String consumerID) async {
    //Done tested
    return await FirebaseFirestore.instance
        .collection('Consumers')
        .doc(consumerID)
        .get();
  }

  //************************ Orders ***********************************/
  addNewOrderToFirebase(Order_object order) async {
    //Done Tested
    await _db.collection('Orders').doc(order.getOrderID).set(order.toMap());
  }

  void updateOrderInfo(
      String orderId, Map<String, dynamic> field_value_map) async {
    //Done tested
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(orderId)
        .update(field_value_map);
  }

  void addItemsToOrder(
      Order_object orderOBJ, List<DailyMenu_Item> dmList) async {
    //Done tested
    double total = 0.0;
    for (var i = 0; i < dmList.length; i++) {
      await _db
          .collection('Orders')
          .doc(orderOBJ.getOrderID)
          .collection('listOfDMitems')
          .doc(dmList[i].getUid)
          .set(dmList[i].toMap());
      print(dmList[i].getPriceAfetrDiscount);
      total = total + dmList[i].getPriceAfetrDiscount;
      int ref = (await _db
              .collection('Providers')
              .doc(dmList[i].getItem().getProviderID)
              .get())
          .data()!['NumberOfItemsInDM'];
      ref = ref - 1;
      updateProviderInfo(orderOBJ.getProviderID, {'NumberOfItemsInDM': ref});
      ref = (await _db
              .collection('Providers')
              .doc(dmList[i].getItem().getProviderID)
              .collection('DailyMenu')
              .doc(dmList[i].getUid)
              .get())
          .data()!['quantity'];
      ref = ref - 1;
      update_DM_Item_Info(
          orderOBJ.getProviderID, dmList[i].getUid, {'quantity': ref});
      if (ref == 0) {
        removeFromPrvoiderDM(orderOBJ.providerID, dmList[0].getUid);
      }
      print(total);
    }
    ;
    print('Total *********:');
    print(total);
    updateOrderInfo(orderOBJ.getOrderID, {'total': total});
  }

  Future<List<Order_object>> retrieve_AllOrders_Of_Consumer(
      String consID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .where('consumerID', isEqualTo: consID)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Order_object.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Order_object>> retrieve_AllOrders_Of_Prov(String provID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .where('providerID', isEqualTo: provID)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Order_object.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Order_object>> retrieve_Some_Orders_Of_Consumer(
      String consID, OrderStatus s1) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .where('consumerID', isEqualTo: consID)
        .where(
          'status',
          isEqualTo: s1.toString().replaceAll('OrderStatus.', ''),
        )
        .get();
    return snapshot.docs
        .map((docSnapshot) => Order_object.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Order_object>> retrieve_Some_Orders_Of_Prov(
      String provID, OrderStatus s1) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .where('providerID', isEqualTo: provID)
        .where(
          'status',
          isEqualTo: s1.toString().replaceAll('OrderStatus.', ''),
        )
        .get();
    return snapshot.docs
        .map((docSnapshot) => Order_object.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Order_object>> retrieveWaitingAndProcess(String provID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .where('providerID', isEqualTo: provID)
        .where(
      'status',
      whereIn: ['waitingForPickUp', 'underProcess'],
    ).get();
    return snapshot.docs
        .map((docSnapshot) => Order_object.fromDocumentSnapshot(docSnapshot))
        .toList();
  }
}
