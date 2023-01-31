import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/widgets/instance.dart';

class Database {

  final String uid;
  Database({this.uid = ""});

  // collection references
  final CollectionReference trackerCollection = FirebaseFirestore.instance.collection('trackers');

  Future updateUserData(String trackerList, List<String> descriptions) async {
    return await trackerCollection.doc(uid).set({
      'list': trackerList,
      'descriptions': descriptions,
    });
  }

  // get firestore stream
  Stream<QuerySnapshot?> get data {
    return trackerCollection.snapshots();
  }

}