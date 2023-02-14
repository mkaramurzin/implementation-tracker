import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/widgets/instance.dart';
import 'package:tracker/services/instance_path.dart';

class Database {

  final String uid;
  Database({required this.uid});

  // collection references
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> setUserData() async {
    List<List<String>> trackerMatrix = [
      ['T10', 'T20', 'T30'],
      ['T40', '', ''],
      ['','',''],
      ['','',''],
      ['','',''],
    ];
    String jsonMatrix = jsonEncode(trackerMatrix);
    var inst = InstancePath(path: "updateUserData error");
    await userCollection.doc(uid).collection("trackers").add({
      'name': 'tab1',
      'list': jsonMatrix,
      'descriptions': ['node1', 'node2', 'node3', 'node4', 'node5'],
    }).then((value) async {
      // return value.path;
      await userCollection
          .doc(uid)
          .collection('trackers')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          inst.path = doc.id;
        });
      });
    });
    await userCollection.doc(uid).collection("trackers").add({
      'name': 'tab2',
      'list': jsonMatrix,
      'descriptions': ['step1', 'step2', 'step3', 'step4', 'step5'],
    });
    await userCollection.doc(uid).collection("trackers").add({
      'name': 'tab3',
      'list': jsonMatrix,
      'descriptions': ['step1', 'step2', 'step3', 'step4', 'step5'],
    });
    await userCollection.doc(uid).set({
      'current_instance': inst.path
    });
    // await trackerCollection.doc(uid).get()
    // .then((doc) {
    //   print(doc['current_instance']);
    // });
    // await trackerCollection.doc(uid).collection('trackers').doc(currentInstance).get()
    // .then((doc) {
    //   print(doc['list']);
    // });
    // await trackerCollection.doc(uid).collection('trackers').doc(currentInstance)
    //     .snapshots().forEach((element) {
    //       print(element.get('list'));
    //     });
  }

  Future<void> updateUserData(String name, List<List<String>> trackerMatrix, List<String> descriptions, String path) async {
    String jsonMatrix = jsonEncode(trackerMatrix);
    await userCollection.doc(uid).collection("trackers").doc(path).set({
      'name': name,
      'list': jsonMatrix,
      'descriptions': descriptions,
    });
  }

  TrackerData? _dataFromSnapshot(DocumentSnapshot doc) {
    var decodedMatrix = jsonDecode(doc.get('list'));
    List<String> descriptions = [];
    List<List<String>> trackerMatrix = List<List<String>>.from(decodedMatrix.map((row){
      return List<String>.from(row.map((value) => (value.toString())));
    }));
    for(var item in doc.get('descriptions')) {
      descriptions.add(item.toString());
    }
    return TrackerData(
        name: doc.get('name') ?? "",
        trackerMatrix: trackerMatrix ?? [[]],
        descriptions: descriptions ?? [],
        path: doc.id
    );
  }

  List<TrackerData?> _listFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      var decodedMatrix = jsonDecode(doc.get('list'));
      List<String> descriptions = [];
      List<List<String>> trackerMatrix = List<List<String>>.from(decodedMatrix.map((row){
        return List<String>.from(row.map((value) => (value.toString())));
      }));
      for(var item in doc.get('descriptions')) {
        descriptions.add(item.toString());
      }
      return TrackerData(
        name: doc.get('name'),
        descriptions: descriptions,
        trackerMatrix: trackerMatrix,
        path: doc.id
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

  Future<void> setPath() async {
    await userCollection.doc(uid).get()
        .then((doc) {
      var inst = InstancePath(path: doc['current_instance']);
      inst.path = doc['current_instance'];
    });
  }

  Future<List<String>> get names async {
    List<String> names = [];
    await userCollection.doc(uid).collection('trackers').get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((DocumentSnapshot document) {
        // Get the document ID
        names.add(document.get('name'));
      });
    });
    return names;
  }

}