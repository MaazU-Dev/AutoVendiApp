import 'dart:async';

import 'package:autovendi/domain/model/model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartViewModel {
  final StreamController _wishlistStreamController =
      StreamController<Wishlist>();

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  void getCart() async {
    await _firebaseFirestore.collection("products").doc("cart").get();

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
