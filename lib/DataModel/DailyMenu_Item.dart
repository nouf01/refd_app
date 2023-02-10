import 'item.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DailyMenu_Item {
  String? _uid;
  Item _item;
  int _quantity;
  double _discount;
  double? _priceAfterDiscount;
  int _choosedCartQuantity;

  DailyMenu_Item({
    required Item item,
    required quantity,
    required discount,
  })  : this._uid = item.getId(),
        this._item = item,
        this._quantity = quantity,
        this._discount = discount,
        this._priceAfterDiscount =
            item.get_originalPrice() - (item.get_originalPrice() * discount),
        this._choosedCartQuantity = 0;

  Map<String, dynamic> toMap() {
    return {
      'item': _item.toMap(),
      'quantity': _quantity,
      'discount': _discount,
      'priceAfterDiscount':
          double.parse((_priceAfterDiscount)!.toStringAsFixed(2)),
      'choosedCartQuantity': _choosedCartQuantity,
    };
  }

  DailyMenu_Item.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> doc)
      : _uid = doc.id,
        _item = Item.fromMap(doc.data()!["item"]),
        _quantity = doc.data()!["quantity"],
        _discount = doc.data()!["discount"],
        _priceAfterDiscount = doc.data()!["priceAfterDiscount"],
        _choosedCartQuantity = doc.data()!["choosedCartQuantity"];

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

  get get_quantity => this._quantity;

  void set_quantity(quantity) {
    this._quantity = quantity;
  }

  get get_discount => this._discount;

  set set_discount(_discount) => this._discount = _discount;

  get getPriceAfetr_discount => this._priceAfterDiscount;

  int get getChoosedCartQuantity => this._choosedCartQuantity;

  void setChoosedCartQuantity(int value) => this._choosedCartQuantity = value;

  void setItem(Map<String, dynamic> t) {
    _item = Item.fromMap(t);
  }
}
