import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:events/models/favorite.dart';
import 'package:events/shared/authentication.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:events/models/event_detail.dart';
import 'package:flutter/material.dart';
import '../models/event_detail.dart';
import 'login_screen.dart';
import '../shared/firestore_helper.dart';

class EventScreen extends StatelessWidget {
  final String uid;
  EventScreen(this.uid);

  @override
  Widget build(BuildContext context) {
    final Authentication auth = new Authentication();
    return Scaffold(
      appBar: AppBar(
        title: Text('Event'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              auth.signOut().then((result) {
                Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => LoginScreen()));
              });
            }
          )
        ],
      ),
      body: EventList(uid)
    );
  }
}

class EventList extends StatefulWidget {
  final String uid;
  EventList(this.uid);

  @override
  _EventListState createState() => _EventListState(uid);
}

class _EventListState extends State<EventList> {
  FirebaseApp _initialization;
  FirebaseFirestore db;
  List<EventDetail> details = [];
  List<Favorite> favorites = [];

  String uid;
  _EventListState(this.uid);

  Future<List<EventDetail>> getDetailsList() async {
    _initialization = await Firebase.initializeApp();
    db = FirebaseFirestore.instance;
    var data = await db.collection('event_details').get();

    var details;
    if (data != null) {
      details = data.docs.map((document) => EventDetail.fromMap(document)).toList();

      int i = 0;
      details.forEach((detail) {
        detail.id = data.docs[i].id;
        i++;
      });
    }

    return details;
  }

  @override
  void initState() {
    if (mounted) {
      getDetailsList().then((data) {
        setState(() {
          details = data;
        });
      });
      FirestoreHelper.getUserFavorites(uid).then((data) {
        setState(() {
          favorites = data;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
        itemCount: (details != null) ? details.length : 0,
        itemBuilder: (context, position) {
          String sub = 'Date: ${details[position].date} - Start: ${details[position].startTime} - End: ${details[position].endTime}';
          Color starColor = (isUserFavorite(details[position].id) ? Colors.amber : Colors.grey);

          return ListTile(
            title: Text(details[position].description),
            subtitle: Text(sub),
            trailing: IconButton(
              icon: Icon(Icons.star, color: starColor),
              onPressed: () {toggleFavorite(details[position]);},
            ),
          );
        },
    );
  }

  void toggleFavorite(EventDetail ed) async {
    if (isUserFavorite(ed.id)) {
      Favorite favorite = favorites.firstWhere((Favorite f) => (f.eventId == ed.id));
      String favId = favorite.id;
      await FirestoreHelper.deleteFavorite(favId);
    } else {
      await FirestoreHelper.addFavorite(ed, widget.uid);
    }
    List<Favorite> updatedFavorites = await FirestoreHelper.getUserFavorites(uid);
    setState(() {
      favorites = updatedFavorites;
    });
  }

  bool isUserFavorite(String eventId) {
    Favorite favorite = favorites.firstWhere(
          (Favorite f) => (f.eventId == eventId),
          orElse: () => null,
    );
    if (favorite == null) {
      return false;
    } else {
      return true;
    }
  }
}

