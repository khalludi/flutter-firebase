import 'package:events/screens/event_screen.dart';
import 'package:events/screens/launch_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // testData();
    return MaterialApp(
      title: 'Events',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: LaunchScreen(),
    );
  }

  Future testData() async {
    final FirebaseApp _initialization = await Firebase.initializeApp();
    FirebaseFirestore db = FirebaseFirestore.instance;
    var data = await db.collection('event_details').get();
    if (data == null) { return data; }

    var details = data.docs.toList();
    details.forEach((d) {
      print(d.id);
    });
  }
}