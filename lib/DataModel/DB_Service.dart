import 'package:cloud_firestore/cloud_firestore.dart';
import 'DailyMenu_Item.dart';
import 'Provider.dart';

import 'item.dart';

class Database {
  Database();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  //************************ Provider **********************/
  addNewProviderToFirebase(Provider provider) async {
    await _db
        .collection('Providers')
        .doc(provider.username)
        .set(provider.toMap());
  }

  static void updateProviderInfo(
      String providerID, Map<String, dynamic> field_value_map) {
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(providerID)
        .update(field_value_map);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> searchForProvider(
      String providerID) async {
    return await FirebaseFirestore.instance
        .collection('Providers')
        .doc(providerID)
        .get();
  }

  Future<List<Provider>> retrieveAllProviders() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Providers").get();
    return snapshot.docs
        .map((docSnapshot) => Provider.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  //************************ Menu **********************/

  void addToProviderMenu(Item newItem) async {
    await _db
        .collection('Providers')
        .doc(newItem.getProviderID)
        .collection('itemsList')
        .doc(newItem.getName() + newItem.getProviderID)
        .set(newItem.toMap());
  }

  void removeFromPrvoiderMenu(Item newItem) async {
    await _db
        .collection('Providers')
        .doc(newItem.getProviderID)
        .collection('itemsList')
        .doc(newItem.getName() + newItem.getProviderID)
        .delete();
  }

  void updateItemInfo(Item item, Map<String, dynamic> field_value_map) {
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(item.getProviderID)
        .collection('itemsList')
        .doc(item.uid)
        .update(field_value_map);
  }

  Future<List<Item>> retrieveMenuItems(String provID) async {
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
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(ref);
    ref = ref + 1;
    updateProviderInfo(
        DM_Item.getItem().getProviderID, {'NumberOfItemsInDM': ref});
  }

  void removeFromPrvoiderDM(String providerID, String itemID) async {
    await _db
        .collection('Providers')
        .doc(providerID)
        .collection('DailyMenu')
        .doc(itemID)
        .delete();
    int ref = (await _db.collection('Providers').doc(providerID).get())
        .data()!['NumberOfItemsInDM'];
    print('&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&');
    print(ref);
    ref = ref - 1;
    updateProviderInfo(providerID, {'NumberOfItemsInDM': ref});
  }

  void update_DM_Item_Info(String providerID, String dmItemID,
      Map<String, dynamic> field_value_map) {
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(providerID)
        .collection('DailyMenu')
        .doc(dmItemID)
        .update(field_value_map);
  }

  Future<List<DailyMenu_Item>> retrieve_DMmenu_Items(String provID) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Providers")
        .doc(provID)
        .collection('DailyMenu')
        .get();
    return snapshot.docs
        .map((docSnapshot) => DailyMenu_Item.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  //************************ Orders/Provider **********************/
}
