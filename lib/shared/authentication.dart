import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class Authentication {
  FirebaseApp _initialization;
  FirebaseAuth _firebaseAuth;

  Future<String> login(String email, String password) async {
    if (_initialization == null) {
      _initialization = await Firebase.initializeApp();
      _firebaseAuth = FirebaseAuth.instance;
    }
    UserCredential authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    User user = authResult.user;
    return user.uid;
  }

  Future<String> signUp(String email, String password) async {
    if (_initialization ==  null) {
      _initialization = await Firebase.initializeApp();
      _firebaseAuth = FirebaseAuth.instance;
    }
    UserCredential authResult =
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    User user = authResult.user;
    return user.uid;
  }

  Future<void> signOut() async {
    if (_initialization ==  null) {
      _initialization = await Firebase.initializeApp();
      _firebaseAuth = FirebaseAuth.instance;
    }
    return _firebaseAuth.signOut();
  }

  Future<User> getUser() async {
    if (_initialization ==  null) {
      _initialization = await Firebase.initializeApp();
      _firebaseAuth = FirebaseAuth.instance;
    }
    User user = _firebaseAuth.currentUser;
    return user;
  }
}