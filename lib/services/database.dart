import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/services/themes.dart';

class Database {

  final String uid;
  Database({required this.uid});

  // collection references
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> setUserData() async {
    List<List<List<String>>> trackerMatrix = [
      [['T10', '#FFA611', '#000000'], ['T20', '#000000', '#000000'], ['T30', '#000000', '#000000']],
      [['T40', '#000000', '#000000']],
      [],
      [],
      [],
    ];
    String jsonMatrix = jsonEncode(trackerMatrix);
    final Timestamp timestamp = Timestamp.now();
    await userCollection.doc(uid).set({
      'theme': "classic"
    });
    await userCollection.doc(uid).collection("trackers").add({
      'name': 'tab1',
      'list': jsonMatrix,
      'descriptions': ['step1', 'step2', 'step3', 'step4', 'step5'],
      'timestamp': FieldValue.serverTimestamp(),
    });
    await userCollection.doc(uid).collection("trackers").add({
      'name': 'tab2',
      'list': jsonMatrix,
      'descriptions': ['node1', 'node2', 'node3', 'node4', 'node5'],
      'timestamp': FieldValue.serverTimestamp(),
    });
    await userCollection.doc(uid).collection("trackers").add({
      'name': 'tab3',
      'list': jsonMatrix,
      'descriptions': ['step1', 'step2', 'step3', 'step4', 'step5'],
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateUserData(String name, List<List<List<String>>> trackerMatrix, List<String> descriptions, String path) async {
    String jsonMatrix = jsonEncode(trackerMatrix);
    DocumentSnapshot snapshot = await userCollection.doc(uid).collection("trackers").doc(path).get();
    Timestamp timestamp = snapshot.get('timestamp');
    await userCollection.doc(uid).collection("trackers").doc(path).set({
      'name': name,
      'list': jsonMatrix,
      'descriptions': descriptions,
      'timestamp': timestamp, // set the timestamp field to the retrieved value
    });
  }

  TrackerData _dataFromSnapshot(DocumentSnapshot doc) {
    var decodedMatrix = jsonDecode(doc.get('list'));
    List<String> descriptions = [];
    List<List<List<String>>> trackerMatrix = List<List<List<String>>>.from(decodedMatrix.map((table) {
      return List<List<String>>.from(table.map((row) {
        return List<String>.from(row.map((value) => (value.toString())));
      }));
    }));
    for (var item in doc.get('descriptions')) {
      descriptions.add(item.toString());
    }
    return TrackerData(
      name: doc.get('name') ?? "",
      trackerMatrix: trackerMatrix ?? [[[]]],
      descriptions: descriptions ?? [],
      path: doc.id,
    );
  }


  List<TrackerData?> _listFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var decodedMatrix = jsonDecode(doc.get('list'));
      List<String> descriptions = [];
      List<List<List<String>>> trackerMatrix = List<List<List<String>>>.from(decodedMatrix.map((table) {
        return List<List<String>>.from(table.map((row) {
          return List<String>.from(row.map((value) => (value.toString())));
        }));
      }));
      for (var item in doc.get('descriptions')) {
        descriptions.add(item.toString());
      }
      return TrackerData(
        name: doc.get('name'),
        descriptions: descriptions,
        trackerMatrix: trackerMatrix,
        path: doc.id,
      );
    }).toList();
  }


  Stream<List<TrackerData?>> get data {
    return userCollection.doc(uid).collection('trackers').snapshots()
        .map(_listFromSnapshot);
  }

  // get firestore snapshots
  Stream<QuerySnapshot> get snapshots {
    return userCollection.doc(uid).collection('trackers').snapshots();
  }

  // get user doc stream
  Stream<TrackerData?> userData(String path) {
    return userCollection.doc(uid).collection('trackers').doc(path).snapshots()
        .map(_dataFromSnapshot);
  }

  Future<List<String>> get tabNames async {
    List<String> names = [];
    await userCollection.doc(uid).collection('trackers')
    .orderBy('timestamp', descending: false).get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        // Get the document ID
        names.add(document.get('name'));
      });
    });
    return names;
  }

  Future<void> changeTheme(String theme) async {
    await userCollection.doc(uid).update({'theme': theme});
    ThemeManager().theme = theme;
  }

}