import 'dart:async';

import 'package:autovendi/domain/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartViewModel {
  final StreamController _wishlistStreamController =
      StreamController<Wishlist>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<bool> deleteProduct(Product product)async{


    DocumentSnapshot snapshot =
    await _firebaseFirestore.collection("products").doc("cart").get();

    print("==============CVM==============");
    print(snapshot['products']);
    print("============CVM===================");

    Wishlist wishlist = Wishlist.fromSnapshot(snapshot);

    if(wishlist.products.length <= 1){
      return false;
    }

    for(int i = 0; i < wishlist.products.length; i++){
      if(wishlist.products[i].name == product.name){
        wishlist.products.removeAt(i);
      }
    }

    await _firebaseFirestore
        .collection("products")
        .doc("cart")
        .update({'products': wishlist.toDocument()});

    return true;
  }

  void getCart() async {

    DocumentSnapshot snapshot =
        await _firebaseFirestore.collection("products").doc("cart").get();

    print("==============CVM==============");
    print(snapshot['products']);
    print("============CVM===================");

    Wishlist wishlist = Wishlist.fromSnapshot(snapshot);

    _wishlistStreamController.add(wishlist);
  }

  Sink get inputWishlistStream => _wishlistStreamController.sink;

  Stream<Wishlist> get outputWishlistStream =>
      _wishlistStreamController.stream.map((value) => value);
}
