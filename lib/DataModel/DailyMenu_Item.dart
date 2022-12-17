import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMenu_Item {
  String? uid;
  Item item;
  int quantity;
  double discount;
  double? priceAfetrDiscount;

  DailyMenu_Item({
    required this.item,
    required this.quantity,
    required this.discount,
  })  : priceAfetrDiscount = item.originalPrice * discount,
        uid = item.getName() + item.getProviderID;

  Map<String, dynamic> toMap() {
    return {
      'item': item.toMap(),
      'quantity': quantity,
      'discount': discount,
      'priceAfetrDiscount': priceAfetrDiscount,
    };
  }

  DailyMenu_Item.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        item = Item.fromMap(doc.data()!["item"]),
        quantity = doc.data()!["quantity"],
        discount = doc.data()!["discount"],
        priceAfetrDiscount = doc.data()!["priceAfetrDiscount"];

  /*DailyMenu_Item.fromMap(Map<String, dynamic> itemMap)
      : providerID = itemMap["providerID"],
        name = itemMap["name"],
        description = itemMap["description"],
        originalPrice = itemMap["originalPrice"],
        imageURL = itemMap["imageURL"];*/

  get getUid => this.uid;

  set setUid(uid) => this.uid = uid;

  Item getItem() {
    return item;
  }

  set setItem(item) => this.item = item;

  get getQuantity => this.quantity;

  set setQuantity(quantity) => this.quantity = quantity;

  get getDiscount => this.discount;

  set setDiscount(discount) => this.discount = discount;

  get getPriceAfetrDiscount => this.priceAfetrDiscount;

  set setPriceAfetrDiscount(priceAfetrDiscount) =>
      this.priceAfetrDiscount = priceAfetrDiscount;
}
