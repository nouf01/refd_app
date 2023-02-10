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
        .doc(provider.get_email.toString().toLowerCase())
        .set(provider.toMap());
  }

  void updateProviderInfo(String providerID, bool nameChanged,
      String newCommercialName, Map<String, dynamic> field_value_map) async {
    //Done tested
    FirebaseFirestore.instance
        .collection('Providers')
        .doc(providerID)
        .update(field_value_map);
    //update search cases if name changed
    if (nameChanged == true) {
      var searchCases = setSearchParam(newCommercialName);
      await FirebaseFirestore.instance
          .collection('Providers')
          .doc(providerID)
          .update({
        'searchCases': searchCases,
        'commercialName': newCommercialName
      });
    }
  }

  List<String> setSearchParam(String caseNumber) {
    caseNumber = caseNumber.toLowerCase();
    List<String> caseSearchList = [];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
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

  Future<List<Provider>> searchForProviderByName(
      //Done tested
      String input) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('Providers')
        .where('searchCases', arrayContains: input)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Provider.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Provider>> retrieveAllProviders() async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Providers").get();
    return snapshot.docs
        .map((docSnapshot) => Provider.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<List<Provider>> filterProvider(List<Tags>? tags) async {
    //Done tested
    List<String> tagsList = [];
    tags!.forEach((element) {
      tagsList.add(element.toString().replaceAll('Tags.', ''));
    });
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Providers")
        .where('tags', arrayContainsAny: tagsList)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Provider.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  void calculateRate(String provID) async {
    int num1stars = (await _db.collection('Providers').doc(provID).get())
        .data()!['num1stars'];
    int num2stars = (await _db.collection('Providers').doc(provID).get())
        .data()!['num2stars'];
    int num3stars = (await _db.collection('Providers').doc(provID).get())
        .data()!['num3stars'];
    int num4stars = (await _db.collection('Providers').doc(provID).get())
        .data()!['num4stars'];
    int num5stars = (await _db.collection('Providers').doc(provID).get())
        .data()!['num5stars'];
    int total = num1stars + num2stars + num3stars + num4stars + num5stars;

    double newRate = (1 * num1stars +
            2 * num2stars +
            3 * num3stars +
            4 * num4stars +
            5 * num5stars) /
        total;
    newRate = double.parse(newRate.toStringAsFixed(1));
    updateProviderInfo(provID, false, '', {'rate': newRate});
  }

  void updateTotalSales(String provID, double amount) async {
    double totalSales = (await _db.collection('Providers').doc(provID).get())
        .data()!['totalSales'];
    totalSales = totalSales + amount;
    totalSales = double.parse(totalSales.toStringAsFixed(2));
    updateProviderInfo(provID, false, '', {'totalSales': totalSales});
  }

  void updateMeals(String provID) async {
    int totalMeals = (await _db.collection('Providers').doc(provID).get())
        .data()!['totalMeals'];
    totalMeals = totalMeals + 1;
    updateProviderInfo(provID, false, '', {'totalMeals': totalMeals});
  }

  //************************ Menu **********************/

  void addToProviderMenu(Item newItem) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(newItem.get_providerID)
        .collection('itemsList')
        .doc()
        .set(newItem.toMap());
  }

  Future<void> removeFromPrvoiderMenu(Item newItem) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(newItem.get_providerID)
        .collection('itemsList')
        .doc(newItem.getId())
        .delete();
  }

  void updateItemInfo(
      String? itemUID, Item item, Map<String, dynamic> field_value_map) async {
    //Done tested
    print('###############################################${itemUID}}');
    print(
        '###############################################${item.get_providerID}}');
    print(itemUID);
    await FirebaseFirestore.instance
        .collection('Providers')
        .doc(item.get_providerID)
        .collection('itemsList')
        .doc(itemUID)
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

  void updateNumOfPick(List<DailyMenu_Item> dmList) async {
    String provID = dmList[0].getItem().get_providerID;
    for (var i = 0; i < dmList.length; i++) {
      int numPick = (await _db
              .collection('Providers')
              .doc(provID)
              .collection('itemsList')
              .doc(dmList[i].get_uid)
              .get())
          .data()!['howManyPickedUp'];
      numPick = numPick + 1;
      updateItemInfo(
          dmList[i].get_uid, dmList[i].getItem(), {'howManyPickedUp': numPick});
    }
  }

  //************************Daily Menu **********************/
  void addToProviderDM(DailyMenu_Item DM_Item) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(DM_Item.getItem().get_providerID)
        .collection('DailyMenu')
        .doc(DM_Item.get_uid)
        .set(DM_Item.toMap());
    int ref = (await _db
            .collection('Providers')
            .doc(DM_Item.getItem().get_providerID)
            .get())
        .data()!['NumberOfItemsInDM'];
    /*ref = ref + 1;
    updateProviderInfo(DM_Item.getItem().get_providerID, false, '',
        {'NumberOfItemsInDM': ref});*/
    updateItemInfo(DM_Item.getItem().getId(), DM_Item.getItem(), {'inDM': 1});
  }

  void removeFromPrvoiderDM(String providerID, DailyMenu_Item item) async {
    //Done tested
    await _db
        .collection('Providers')
        .doc(providerID)
        .collection('DailyMenu')
        .doc(item.get_uid)
        .delete();
    int ref = (await _db.collection('Providers').doc(providerID).get())
        .data()!['NumberOfItemsInDM'];
    ref = ref - 1;
    updateProviderInfo(providerID, false, '', {'NumberOfItemsInDM': ref});
    updateItemInfo(item.get_uid, item.getItem(), {'inDM': 0});
  }

  void update_DM_Item_Info(String providerID, String dmItemID,
      Map<String, dynamic> field_value_map) async {
    //Done tested
    print('#########################################    ${dmItemID}');
    await FirebaseFirestore.instance
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
        .doc(consumer.get_email())
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

  Stream<DocumentSnapshot<Map<String, dynamic>>> searchForConsumerStream(
      String consumerID) {
    //Done tested
    return FirebaseFirestore.instance
        .collection('Consumers')
        .doc(consumerID)
        .snapshots();
  }

  //************************ Orders ***********************************/

  addNewOrderToFirebase(Order_object order) async {
    //Done Tested
    await _db.collection('Orders').doc(order.getorderID).set(order.toMap());
  }

  void updateOrderInfo(
      String orderId, Map<String, dynamic> field_value_map) async {
    //Done tested
    await FirebaseFirestore.instance
        .collection('Orders')
        .doc(orderId)
        .update(field_value_map);
  }

  void setOrderTimer(String orderID, int timeLeft) async {
    await _db
        .collection('Orders')
        .doc(orderID)
        .update({'remainingTimer': timeLeft});
  }

  Future<int> getOrderRemainingTimer(String orderID) async {
    return (await _db.collection('Orders').doc(orderID).get())
        .data()!['remainingTimer'];
  }

  void addItemsToOrder(
      Order_object orderOBJ, List<DailyMenu_Item> dmList) async {
    //Done tested
    double total = 0.0;
    for (var i = 0; i < dmList.length; i++) {
      await _db
          .collection('Orders')
          .doc(orderOBJ.getorderID)
          .collection('listOfDMitems')
          .doc(dmList[i].get_uid)
          .set(dmList[i].toMap());
      print(dmList[i].getPriceAfetr_discount);
      total = total + dmList[i].getPriceAfetr_discount;
      int ref = (await _db
              .collection('Providers')
              .doc(dmList[i].getItem().get_providerID)
              .collection('DailyMenu')
              .doc(dmList[i].get_uid)
              .get())
          .data()!['quantity'];
      ref = ref - dmList[i].getChoosedCartQuantity;
      update_DM_Item_Info(
          orderOBJ.get_ProviderID, dmList[i].get_uid, {'quantity': ref});
      if (ref == 0) {
        removeFromPrvoiderDM(orderOBJ.get_ProviderID, dmList[i]);
        /*int numOfItems = (await _db
                .collection('Providers')
                .doc(dmList[i].getItem().get_providerID)
                .get())
            .data()!['NumberOfItemsInDM'];
        numOfItems = numOfItems - 1;
        updateProviderInfo(orderOBJ.get_ProviderID, false, '',
            {'NumberOfItemsInDM': numOfItems});*/
      }
      print(total);
    }
    print('Total *********:');
    print(total);
    updateOrderInfo(orderOBJ.getorderID, {'total': total});
  }

  void returnItemsToDailyMenu(
      List<DailyMenu_Item> orderItems, String provID) async {
    List<DailyMenu_Item> provItems = await retrieve_DMmenu_Items(provID);
    orderItems.forEach((o) {
      bool isExist = false;
      provItems.forEach((p) async {
        if (o.get_uid == p.get_uid) {
          //the item exist => increment the quantity
          isExist = true;
          int currentProvQuantity = (await _db
                  .collection('Providers')
                  .doc(provID)
                  .collection('DailyMenu')
                  .doc(p.get_uid)
                  .get())
              .data()!['quantity'];
          int choosedOrderQuantuty = o.getChoosedCartQuantity;
          currentProvQuantity = currentProvQuantity + choosedOrderQuantuty;
          update_DM_Item_Info(
              provID, p.get_uid, {'quantity': currentProvQuantity});
        }
      });
      if (isExist == false) {
        o.set_quantity(o.getChoosedCartQuantity);
        Item tm = o.getItem();
        tm.set_inDM(1);
        var map = tm.toMap();
        /*var map = {      'providerID': tm.get_providerID,
      'name': tm.get_name(),
      'description': tm.getDecription(),
      'originalPrice': tm.get_originalPrice(),
      'inDM': tm.get_inDM(),
      'howManyPickedUp': tm.get_HowManyPicked(),
      'imageURL': tm.get_imageURL(),}*/
        o.setItem(map);
        addToProviderDM(o);
        updateItemInfo(o.get_uid, tm, {'inDM': 1});
      }
    });
    List<DailyMenu_Item> list = await retrieve_DMmenu_Items(provID);
    print('hhhhhhhhhhhhhhhhhhhhh ${list.length}');
    updateProviderInfo(provID, false, '', {'NumberOfItemsInDM': list.length});
  }

  Future<List<DailyMenu_Item>> retrieve_Order_Items(String orderID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .doc(orderID)
        .collection('listOfDMitems')
        .get();
    return snapshot.docs
        .map((docSnapshot) => DailyMenu_Item.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  /*Future<List<Order_object>> retrieve_AllOrders_Of_Consumer(
      String consID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .where('consumerID', isEqualTo: consID)
        .get();
    return snapshot.docs
        .map((docSnapshot) => Order_object.fromDocumentSnapshot(docSnapshot))
        .toList();
  }*/

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieve_AllOrders_Of_Consumer(
      String consID) {
    //Done tested
    var snapshot = _db
        .collection("Orders")
        .where('consumerID', isEqualTo: consID)
        .orderBy('date', descending: true)
        .snapshots();
    return snapshot;
    /*where('providerID', isEqualTo: provID)*/
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieve_AllOrders_Of_Prov(
      String provID) {
    //Done tested
    var snapshot = _db
        .collection("Orders")
        .where('providerID', isEqualTo: provID)
        .orderBy('date', descending: true)
        .snapshots();
    return snapshot;
    /*where('providerID', isEqualTo: provID)*/
  }

  Future<List<Order_object>> retrieve_Some_Orders_Of_Consumer(
      String consID, String s1) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot = await _db
        .collection("Orders")
        .where('consumerID', isEqualTo: consID)
        .where(
          'status',
          isEqualTo: s1,
        )
        .get();
    return snapshot.docs
        .map((docSnapshot) => Order_object.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> retrieve_Some_Orders_Of_Prov(
      String provID, String s1) {
    //Done tested
    var snapshot = _db
        .collection("Orders")
        .where('providerID', isEqualTo: provID)
        .where('status', isEqualTo: s1)
        .orderBy('date', descending: true)
        .snapshots();
    return snapshot;
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

  //*************************************************************************************** */

  //addToCart
  Future<void> addToCart_DMitems(
      String consumerID, DailyMenu_Item DM_Item) async {
    await _db
        .collection('Consumers')
        .doc(consumerID)
        .collection('cart')
        .doc(DM_Item.get_uid)
        .set(DM_Item.toMap());
    int num = (await _db.collection('Consumers').doc(consumerID).get())
        .data()!['numOfCartItems'];
    num = num + DM_Item.getChoosedCartQuantity;
    double total = (await _db.collection('Consumers').doc(consumerID).get())
        .data()!['cartTotal'];
    total = total +
        (DM_Item.getPriceAfetr_discount * DM_Item.getChoosedCartQuantity);

    total = (total);

    updateConsumerInfo(consumerID, {'cartTotal': total, 'numOfCartItems': num});
  }

  Future<double> getTotalCart(String consumerID) async {
    return (await _db.collection('Consumers').doc(consumerID).get())
        .data()!['cartTotal'];
  }

  //remove from cart
  Future<void> removeFromCart(
      String consumID, DailyMenu_Item dmItem, bool alreadyZero) async {
    //Done tested
    await _db
        .collection('Consumers')
        .doc(consumID)
        .collection('cart')
        .doc(dmItem.get_uid)
        .delete();

    /*int num = (await _db.collection('Consumers').doc(consumID).get())
        .data()!['numOfCartItems'];
    num = num - 1;

    updateConsumerInfo(consumID, {'numOfCartItems': num});*/

    /*double total = (await _db.collection('Consumers').doc(consumID).get())
        .data()!['cartTotal'];
    if (alreadyZero == false) {
      total = total -
          (dmItem.getPriceAfetr_discount * dmItem.getChoosedCartQuantity);
      total = (total);
      if (total <= 0.0) {
        total = 0.001;
      }
      updateConsumerInfo(consumID, {'cartTotal': total});
    }*/
  }

  Future<void> incrementQuantity(String consumID, DailyMenu_Item dmItem) async {
    //get prev quantity
    int quantity = (await _db
            .collection('Consumers')
            .doc(consumID)
            .collection('cart')
            .doc(dmItem.get_uid)
            .get())
        .data()!['choosedCartQuantity'];
    quantity = quantity + 1;
    //update quantity in database
    FirebaseFirestore.instance
        .collection('Consumers')
        .doc(consumID)
        .collection('cart')
        .doc(dmItem.get_uid)
        .update({'choosedCartQuantity': quantity});
    //update total
    double total = (await _db.collection('Consumers').doc(consumID).get())
        .data()!['cartTotal'];
    total = total + (dmItem.getPriceAfetr_discount);
    //update num
    int num = (await _db.collection('Consumers').doc(consumID).get())
        .data()!['numOfCartItems'];
    num = num + 1;
    updateConsumerInfo(consumID, {'cartTotal': total, 'numOfCartItems': num});
  }

  Future<void> decermentQuantity(String consumID, DailyMenu_Item dmItem) async {
    //get prev quantity
    int quantity = (await _db
            .collection('Consumers')
            .doc(consumID)
            .collection('cart')
            .doc(dmItem.get_uid)
            .get())
        .data()!['choosedCartQuantity'];
    quantity = quantity - 1;

    //update quantity in database
    FirebaseFirestore.instance
        .collection('Consumers')
        .doc(consumID)
        .collection('cart')
        .doc(dmItem.get_uid)
        .update({'choosedCartQuantity': quantity});

    //update total
    double total = (await _db.collection('Consumers').doc(consumID).get())
        .data()!['cartTotal'];
    total = total - (dmItem.getPriceAfetr_discount);
    //update num
    int num = (await _db.collection('Consumers').doc(consumID).get())
        .data()!['numOfCartItems'];
    num = num - 1;
    updateConsumerInfo(consumID, {'cartTotal': total, 'numOfCartItems': num});
    //remove if zero
    if (quantity == 0) {
      removeFromCart(consumID, dmItem, true);
    }
  }

  Future<List<DailyMenu_Item>> retrieve_Cart_Items(String consID) async {
    //Done tested
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await _db.collection("Consumers").doc(consID).collection('cart').get();
    return snapshot.docs
        .map((docSnapshot) => DailyMenu_Item.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  Future<bool> isItemInCart(DailyMenu_Item dm, String consID) async {
    bool result = false;
    List<DailyMenu_Item> userCart = await retrieve_Cart_Items(consID);
    userCart.forEach((element) {
      if (element.get_uid == dm.get_uid) {
        result = true;
      }
    });
    return result;
  }

  void emptyTheCart(String consID) async {
    var collection = _db.collection('Consumers').doc(consID).collection('cart');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    updateConsumerInfo(consID, {'cartTotal': 0.001, 'numOfCartItems': 0});
  }
}
