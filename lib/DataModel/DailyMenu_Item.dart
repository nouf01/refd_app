import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMenu_Item {
  String? _uid;
  Item _item;
  int _quantity;
  double _discount;
  double? _priceAfterDiscount;

  DailyMenu_Item({
    required item,
    required quantity,
    required discount,
  })  : this._item = item,
        this._quantity = quantity,
        this._discount = discount,
        this._priceAfterDiscount = item.originalPrice * discount;

  Map<String, dynamic> toMap() {
    return {
      'item': _item.toMap(),
      'quantity': _quantity,
      'discount': _discount,
      'priceAfterDiscount': _priceAfterDiscount,
    };
  }

  DailyMenu_Item.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : _uid = doc.id,
        _item = Item.fromMap(doc.data()!["item"]),
        _quantity = doc.data()!["quantity"],
        _discount = doc.data()!["discount"],
        _priceAfterDiscount = doc.data()!["priceAfterDiscount"];

  /*DailyMenu_Item.fromMap(Map<String, dynamic> itemMap)
      : providerID = itemMap["providerID"],
        name = itemMap["name"],
        description = itemMap["description"],
        originalPrice = itemMap["originalPrice"],
        imageURL = itemMap["imageURL"];*/

  get get_uid => this._uid;

  set set_uid(_uid) => this._uid = _uid;

  Item getItem() {
    return _item;
  }

  set setItem(item) => this._item = item;

  get get_quantity => this._quantity;

  set set_quantity(_quantity) => this._quantity = _quantity;

  get get_discount => this._discount;

  set set_discount(_discount) => this._discount = _discount;

  get getPriceAfetr_discount => this._priceAfterDiscount;

  set setPriceAfetr_discount(priceAfetrDiscount) =>
      this._priceAfterDiscount = priceAfetrDiscount;
}
