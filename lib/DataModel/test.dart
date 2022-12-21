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

  // addProviderToFirebase
  Provider p1 = Provider(
      username: 'PizzanIn2022',
      commercialName: 'Pizza In',
      commercialReg: '543268376',
      email: 'pizzain@mail.com',
      phoneNumber: '0556773201',
      accountStatus: Status.Active,
      rate: 4.75);
  db.addNewProviderToFirebase(p1);

  //add tags to provider
  db.addToProviderTags(
      p1.getUsername, [Tags.italian, Tags.pizza, Tags.fastFood]);

  db.addToProviderTags('MacDonalds2008', [
    Tags.american,
    Tags.fastFood,
  ]);

  //get Tags of provider
  List<String>? tagList = await db.getProviderTags(p1.getUsername);

  tagList?.forEach((element) {
    print(element);
  });

  //change the status of the provider
  db.setAccountStatus(p1.getUsername, Status.Active);

  //update provider info
  db.updateProviderInfo(
      p1.getUsername, {'username': 'PizzaIn2023', 'rate': 5.0});

  // search for provider
  Provider p2 =
      Provider.fromDocumentSnapshot(await db.searchForProvider('DrCafe'));
  print(p2.getUsername);
  print(p2.getEmail);
  print(p2.getCommercialName);

  //retrive all providers
  List<Provider> pList = await db.retrieveAllProviders();
  pList.forEach((e) {
    print(e.getUsername);
    print(e.getEmail);
    print(e.getCommercialName);
  });

  //Add new Item to a provider
  Item t1 = Item(
      providerID: p1.getUsername,
      name: 'classic pizza',
      description: 'describe pizza',
      originalPrice: 15);
  Item t2 = Item(
      providerID: p1.getUsername,
      name: 'vegatables pizza',
      description: 'describe vegan pizza',
      originalPrice: 10);
  db.addToProviderMenu(t1);

  //remove item from menu
  db.removeFromPrvoiderMenu(t1);

  //update item info
  db.updateItemInfo(t1, {'name': 'pizza', 'originalPrice': 17});

  //retrive all menu items
  List<Item> menu = await db.retrieveMenuItems('MacDonalds2008');
  menu.forEach((e) {
    print(e.getName());
    print(e.getDecription());
    print(e.getOriginalPrice());
  });

  //add dailymenu item to daily menu of a provider
  DailyMenu_Item d1 = DailyMenu_Item(item: t1, discount: 0.5, quantity: 5);
  DailyMenu_Item d2 = DailyMenu_Item(item: t2, discount: 0.5, quantity: 5);
  db.addToProviderDM(d2);

  //remove from dailt menu
  db.removeFromPrvoiderDM(p1.getUsername, d2.getUid);

  //update daily menu item info
  db.update_DM_Item_Info(
      p1.getUsername, d1.getUid, {'discount': 0.7, 'qunatity': 2});

  //retrive daily menu item of one provider
  List<DailyMenu_Item> dMenu = await db.retrieve_DMmenu_Items(p1.getUsername);
  dMenu.forEach((e) {
    print(e.getItem().getName());
    print(e.getQuantity);
    print(e.getDiscount);
  });

  //create new consumer
  Consumer c1 = Consumer(
      name: 'Nouf',
      email: 'nouf888s@gmail.com',
      phoneNumber: '0531180988',
      cancelCounter: 0,
      profilePhotoURL:
          'https://icon-library.com/images/anonymous-avatar-icon/anonymous-avatar-icon-25.jpg');
  db.addNewConsumerToFirebase(c1);

  //update consumer info
  db.updateConsumerInfo(c1.getEmail(), {'name': 'Nouf Alsubie'});

  //search fpr provider
  Consumer c2 = Consumer.fromDocumentSnapshot(
      await db.searchForConsumer('sara@mail.com'));
  print(c2.getPhoneNumber());

  //increment or decrment cancel counter
  db.updateCancelCounter(c1.getEmail(), true); // to increment
  db.updateCancelCounter(c1.getEmail(), false); // to decrement

  //create new order and add for firebase
  Order_object o1 = Order_object(
      date: DateTime.now(),
      total: 0.0,
      providerID: p1.getUsername,
      consumerID: c2.getEmail(),
      status: OrderStatus.underProcess);
  Order_object o2 = Order_object(
      date: DateTime.now(),
      total: 0.0,
      providerID: 'DrCade',
      consumerID: c2.getEmail(),
      status: OrderStatus.waitingForPickUp);

  db.addNewOrderToFirebase(o1);
  db.addNewOrderToFirebase(o2);

  //add items to order
  db.addItemsToOrder(o1, [d1, d2]);

  //retrive orders of specific provider:
  List<Order_object> ordersList =
      await db.retrieve_AllOrders_Of_Prov(p1.getUsername);
  ordersList.forEach((e) {
    print(e.getOrderID);
    print(e.getStatus);
    print(e.getDate);
  });
}
