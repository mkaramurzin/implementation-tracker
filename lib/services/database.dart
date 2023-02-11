import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/widgets/instance.dart';
import 'package:tracker/services/instance_path.dart';

class Database {

  final String uid;
  Database({required this.uid});

  // collection references
  final CollectionReference trackerCollection = FirebaseFirestore.instance.collection('users');

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
    await trackerCollection.doc(uid).collection("trackers").add({
      'list': jsonMatrix,
      'descriptions': ['node1', 'node2', 'node3', 'node4', 'node5'],
    }).then((value) async {
      // return value.path;
      await trackerCollection
          .doc(uid)
          .collection('trackers')
          .get()
          .then((QuerySnapshot snapshot) {
        snapshot.docs.forEach((doc) {
          inst.path = doc.id;
        });
      });
    });
    await trackerCollection.doc(uid).set({
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

  Future<void> updateUserData(List<List<String>> trackerMatrix, List<String> descriptions) async {
    var inst = InstancePath(path: "path");
    String jsonMatrix = jsonEncode(trackerMatrix);
    await trackerCollection.doc(uid).collection("trackers").doc(inst.path).set({
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
        trackerMatrix: trackerMatrix ?? [[]],
        descriptions: descriptions ?? []
    );
  }

  // get firestore stream
  // Stream<List<TrackerData>> get data {
  //   return trackerCollection.snapshots()
  //       .map(_dataFromSnapshot);
  // }

  // get user doc stream
  Stream<TrackerData?> get userData {
    var inst = InstancePath(path: "");
    return trackerCollection.doc(uid).collection('trackers').doc(inst.path).snapshots()
        .map(_dataFromSnapshot);
  }

  Future<void> setPath() async {
    await trackerCollection.doc(uid).get()
        .then((doc) {
      var inst = InstancePath(path: doc['current_instance']);
      inst.path = doc['current_instance'];
    });
  }

}