import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  String providerID;
  String name;
  String uid;
  String description;
  double originalPrice;
  String? imageURL; //or id based on fire storage

  Item({
    required this.providerID,
    required this.name,
    required this.description,
    required this.originalPrice,
    this.imageURL,
  }) : uid = name + providerID;

  Map<String, dynamic> toMap() {
    return {
      'providerID': providerID,
      'name': name,
      'description': description,
      'originalPrice': originalPrice,
      'imageURL': imageURL,
    };
  }

  Item.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        providerID = doc.data()!["providerID"],
        name = doc.data()!["name"],
        description = doc.data()!["description"],
        originalPrice = doc.data()!["originalPrice"],
        imageURL = doc.data()!['imageURL'];

  Item.fromMap(Map<String, dynamic> itemMap)
      : uid = itemMap["providerID"] + itemMap["name"],
        providerID = itemMap["providerID"],
        name = itemMap["name"],
        description = itemMap["description"],
        originalPrice = itemMap["originalPrice"],
        imageURL = itemMap["imageURL"];

  String get getProviderID => this.providerID;
  set setProviderID(String providerID) => this.providerID = providerID;

  void setName(newName) {
    name = newName;
  }

  void setImageURL(newImageURL) {
    imageURL = newImageURL;
  }

  void setDescription(newDescription) {
    description = newDescription;
  }

  void setOriginalPrice(newOriginalPrice) {
    originalPrice = newOriginalPrice;
  }

  String getId() {
    return uid;
  }

  String getName() {
    return name;
  }

  String getDecription() {
    return description;
  }

  double getOriginalPrice() {
    return originalPrice;
  }

  String? getImageURL() {
    return imageURL;
  }
}
