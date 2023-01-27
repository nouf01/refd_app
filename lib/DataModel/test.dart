import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:refd_app/DataModel/DB_Service.dart';
import 'package:refd_app/DataModel/DailyMenu_Item.dart';
import 'package:refd_app/DataModel/Order.dart';
import 'package:refd_app/DataModel/Provider.dart';
import 'package:refd_app/DataModel/Consumer.dart';
import 'package:flutter/material.dart';
import 'package:refd_app/DataModel/item.dart';

void test() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  //create database object
  Database db = Database();

  //addProviderToFirebase
  Provider p1 = Provider(
    Lang: 0.1,
    Lat: 0.1,
    commercialName: 'Lilio Patisserie',
    commercialReg: '2345765438',
    email: 'Lilio@mail.com',
    phoneNumber: '0532280911',
    accountStatus: Status.Active,
    rate: 4.8,
    tagList: [Tags.sweets, Tags.bakery, Tags.pastries],
    logoURL:
        'https://scontent.fruh4-6.fna.fbcdn.net/v/t39.30808-6/310262705_637068164463857_4882875752757066118_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=09cbfe&_nc_ohc=J4YbzzjCPboAX8oqDSR&_nc_ht=scontent.fruh4-6.fna&oh=00_AfDNV5xsRAxvmGgvkBCzBgliVYN2cwFTwdHx51rTGXm40g&oe=63AE310F',
  );
  db.addNewProviderToFirebase(p1);

  //add tags to provider
  db.addToProviderTags(
      p1.get_email, [Tags.italian, Tags.pizza, Tags.fastFood, Tags.sushi]);

  db.addToProviderTags('MacDonalds2008', [
    Tags.american,
    Tags.fastFood,
  ]);

  //get Tags of provider
  List<String>? tagList = await db.getProviderTags(p1.get_email);

  tagList?.forEach((element) {
    print(element);
  });

  //change the status of the provider
  db.setAccountStatus(p1.get_email, Status.Active);

  //update provider info
  db.updateProviderInfo(
      p1.get_email, false, '', {'username': 'PizzaIn2023', 'rate': 5.0});

  // search for provider
  Provider p2 =
      Provider.fromDocumentSnapshot(await db.searchForProvider('DrCafe'));
  print(p2.get_email);
  print(p2.get_email);
  print(p2.get_commercialName);

  //retrive all providers
  List<Provider> pList = await db.retrieveAllProviders();
  pList.forEach((e) {
    print(e.get_email);
    print(e.get_email);
    print(e.get_commercialName);
  });

  //Add new Item to a provider
  Item t1 = Item(
      providerID: p1.get_email,
      name: 'classic pizza',
      description: 'describe pizza',
      originalPrice: 15,
      imageURL: '');
  Item t2 = Item(
      providerID: p1.get_email,
      name: 'vegatables pizza',
      description: 'describe vegan pizza',
      originalPrice: 10,
      imageURL: '');
  db.addToProviderMenu(t1);

  //remove item from menu
  db.removeFromPrvoiderMenu(t1);

  //update item info
  db.updateItemInfo(t1, {'name': 'pizza', 'originalPrice': 17});

  //retrive all menu items
  List<Item> menu = await db.retrieveMenuItems('MacDonalds2008');
  menu.forEach((e) {
    print(e.get_name());
    print(e.getDecription());
    print(e.get_originalPrice());
  });

  //add dailymenu item to daily menu of a provider
  DailyMenu_Item d1 = DailyMenu_Item(item: t1, discount: 0.5, quantity: 5);
  DailyMenu_Item d2 = DailyMenu_Item(item: t2, discount: 0.5, quantity: 5);

  db.addToProviderDM(d2);

  //remove from dailt menu
  db.removeFromPrvoiderDM(p1.get_email, d2.get_uid);

  //update daily menu item info
  db.update_DM_Item_Info(
      p1.get_email, d1.get_uid, {'discount': 0.7, 'qunatity': 2});

  //retrive daily menu item of one provider
  List<DailyMenu_Item> dMenu = await db.retrieve_DMmenu_Items(p1.get_email);
  dMenu.forEach((e) {
    print(e.getItem().get_name());
    print(e.get_quantity);
    print(e.get_discount);
  });

  //create new consumer
  Consumer c1 = Consumer(
      name: 'Nouf',
      email: 'nouf888s@gmail.com',
      phoneNumber: '0531180988',
      cancelCounter: 0);
  db.addNewConsumerToFirebase(c1);

  //update consumer info
  db.updateConsumerInfo(c1.get_email(), {'name': 'Nouf Alsubie'});

  //search fpr cons
  Consumer c2 = Consumer.fromDocumentSnapshot(
      await db.searchForConsumer('sara@mail.com'));
  print(c2.get_phoneNumber());

  //increment or decrment cancel counter
  db.updateCancelCounter(c1.get_email(), true); // to increment
  db.updateCancelCounter(c1.get_email(), false); // to decrement

  /*create new order and add for firebase
  Order_object o1 = Order_object(
      date: DateTime.now(),
      total: 0.0,
      providerID: p1.get_email,
      consumerID: c2.get_email(),
      status: OrderStatus.underProcess,
      providerLogo: '',
      providerName: '');
  Order_object o2 = Order_object(
      date: DateTime.now(),
      total: 0.0,
      providerID: 'DrCade',
      consumerID: c2.get_email(),
      status: OrderStatus.waitingForPickUp,
      providerLogo: '',
      providerName: '');

  db.addNewOrderToFirebase(o1);
  db.addNewOrderToFirebase(o2);
*/
  //add items to order
  //db.addItemsToOrder(o1, [d1, d2]);

  //retrive orders of specific provider:
  /*List<Order_object> ordersList =
      await db.retrieve_AllOrders_Of_Prov(p1.getUsername);
  ordersList.forEach((e) {
    print(e.getOrderID);
    print(e.getStatus);
    print(e.getDate);
  });*/

  List<DailyMenu_Item> romnsiyah_DMItems =
      await db.retrieve_DMmenu_Items('Alromansiah@mail.com');

  DailyMenu_Item d0 = romnsiyah_DMItems[1];
  d0.setChoosedCartQuantity(1);

  db.addToCart_DMitems('nouf888s@gmail.com', d0);

  List<DailyMenu_Item> cart =
      await db.retrieve_Cart_Items('nouf888s@gmail.com');

  print('**********************************************');
  cart.forEach((element) {
    print(element.getItem().get_name());
    print(element.getChoosedCartQuantity);
  });
}


 /*
   QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("Consumers").get();
 
 snapshot.docs.forEach((docSnapshot) async {
    await _db.collection('Consumers').doc(docSnapshot.id).set({
      'name': docSnapshot.id.substring(0, 2),
      'email': docSnapshot.id,
      'phoneNumber': '0558863667',
      'cancelCounter': 0,
      'cartTotal': 0.0,
    });
  });
  
  
    QuerySnapshot<Map<String, dynamic>> snapshot =
      await _db.collection("Consumers").get();

  snapshot.docs.forEach((docSnapshot) async {
    await _db
        .collection('Consumers')
        .doc(docSnapshot.id)
        .update({'numOfCartItems': 0});
  });
  
  */