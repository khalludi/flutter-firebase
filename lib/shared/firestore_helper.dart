import 'dart:ffi';

import '../models/event_detail.dart';
import '../models/favorite.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreHelper {
  static FirebaseApp _initializer;
  static FirebaseFirestore db;

  static Future addFavorite(EventDetail eventDetail, String uid) async {
    if (_initializer == null) {
      _initializer = await Firebase.initializeApp();
      db = FirebaseFirestore.instance;
    }
    Favorite fav = Favorite(null, uid, eventDetail.id);
    var result = db.collection('favorites').add(fav.toMap())
      .then((value) => print(value))
      .catchError((error) => print(error));
    return result;
  }

  static Future<List<Favorite>> getUserFavorites(String uid) async {
    List<Favorite> favs;
    QuerySnapshot docs = await db.collection('favorites')
      .where('userId', isEqualTo: uid).get();
    if (docs != null) {
      favs = docs.docs.map((e) => Favorite.map(e)).toList();
    }
    return favs;
  }

  static Future deleteFavorite(String favId) async {
    if (_initializer == null) {
      _initializer = await Firebase.initializeApp();
      db = FirebaseFirestore.instance;
    }
    await db.collection('favorites').doc(favId).delete();
  }
}