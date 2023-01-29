import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/widgets/instance.dart';

class Database {

  final String uid;
  Database({required this.uid});

  // collection references
  final CollectionReference trackerCollection = FirebaseFirestore.instance.collection('trackers');

  Future updateUserData(int currentInstance) async {
    return await trackerCollection.doc(uid).set({
      'currentInstance': currentInstance,
    });
  }

}