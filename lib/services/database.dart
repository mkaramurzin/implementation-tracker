import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/widgets/instance.dart';

class Database {

  final String uid;
  Database({required this.uid});

  // collection references
  final CollectionReference trackerCollection = FirebaseFirestore.instance.collection('trackers');

  Future updateUserData(List<List<String>> trackerMatrix, List<String> descriptions) async {
    String jsonMatrix = jsonEncode(trackerMatrix);
    return await trackerCollection.doc(uid).set({
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
    return trackerCollection.doc(uid).snapshots()
        .map(_dataFromSnapshot);
  }

}