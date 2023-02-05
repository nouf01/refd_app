import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String _providerID;
  String _name;
  String? _uid;
  String _description;
  double _originalPrice;
  String _imageURL; //or id based on fire storage
  int _inDm;
  int _howManyPickedUp;

  Item({
    required providerID,
    required name,
    required description,
    required originalPrice,
    required imageURL,
  })  : this._providerID = providerID,
        this._description = description,
        this._name = name,
        this._originalPrice = originalPrice,
        this._inDm = 0,
        this._howManyPickedUp = 0,
        this._imageURL = imageURL;

  Map<String, dynamic> toMap() {
    return {
      'providerID': _providerID,
      'name': _name,
      'description': _description,
      'originalPrice': _originalPrice,
      'inDM': _inDm,
      'howManyPickedUp': _howManyPickedUp,
      'imageURL': _imageURL,
    };
  }

  Item.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : _uid = doc.id,
        _providerID = doc.data()!["providerID"],
        _name = doc.data()!["name"],
        _description = doc.data()!["description"],
        _originalPrice = doc.data()!["originalPrice"],
        _howManyPickedUp = doc.data()!['howManyPickedUp'],
        _inDm = doc.data()!['inDM'],
        _imageURL = doc.data()!['imageURL'];

  Item.fromMap(Map<String, dynamic> itemMap)
      : _providerID = itemMap["providerID"],
        _name = itemMap["name"],
        _description = itemMap["description"],
        _originalPrice = itemMap["originalPrice"],
        _howManyPickedUp = itemMap['howManyPickedUp'],
        _inDm = itemMap['inDM'],
        _imageURL = itemMap["imageURL"];

  String get get_providerID => this._providerID;
  set set_providerID(String _providerID) => this._providerID = _providerID;

  void set_name(new_name) {
    _name = new_name;
  }

  void set_imageURL(new_imageURL) {
    _imageURL = new_imageURL;
  }

  void set_description(new_description) {
    _description = new_description;
  }

  void set_originalPrice(new_originalPrice) {
    _originalPrice = new_originalPrice;
  }

  void setProvID(String value) {
    this._providerID = value;
  }

  String? getId() {
    return _uid;
  }

  String get_name() {
    return _name;
  }

  String getDecription() {
    return _description;
  }

  double get_originalPrice() {
    return _originalPrice;
  }

  String get_imageURL() {
    return _imageURL;
  }

  int get_inDM() {
    return _inDm;
  }

  int get_HowManyPicked() {
    return _howManyPickedUp;
  }

  void set_inDM(int value) {
    _inDm = value;
  }
}
