import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/pages/loading.dart';
import 'package:tracker/services/database.dart';
import 'package:tracker/widgets/trackers/active.dart';

import '../services/auth.dart';

class TrackerForm extends StatefulWidget {
  String path;
  TrackerForm({super.key, required this.path});

  @override
  State<TrackerForm> createState() => _TrackerFormState();
}

class _TrackerFormState extends State<TrackerForm> {

  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Active newTracker = Active(name: '', deleteButton: Container());
  final AuthService _auth = AuthService();


  void updateTracker() {
    newTracker = Active(name: _textController.text, deleteButton: Container());
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      height: MediaQuery.of(context).size.height * 0.25,
      child: StreamBuilder<TrackerData?>(
        stream: Database(uid: _auth.user!.uid).userData(widget.path),
        builder: (context, snapshot) {
          if(snapshot.hasData) {

            TrackerData? data = snapshot.data;
            List<List<String>> trackerMatrix = data!.trackerMatrix;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: TextFormField(
                      onChanged: (text) {
                        setState(() {
                          updateTracker();
                        });
                      },
                      controller: _textController,
                      autofocus: true,
                      decoration: InputDecoration(
                          labelText: 'Tracker Name'
                      ),
                      validator: (text) {
                        if(_textController.text.isEmpty) {
                          return "Please name the tracker";
                        } else if(trackerMatrix.any((sublist) => sublist.where((name) => name == _textController.text).isNotEmpty)) {
                          return "Tracker with that name already exists";
                        }
                        // else if(trackerMatrix[0].where((element) => element.fill == false).length == rowMax) {
                        //   return "The bottom row cannot hold anymore trackers";
                        // }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  newTracker,
                  SizedBox(height: 20),
                  ElevatedButton(
                    child: Text("Add"),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        trackerMatrix[0].add(_textController.text);
                        await Database(uid: _auth.user!.uid).updateUserData(
                          data.name,
                          trackerMatrix,
                          data.descriptions,
                          data.path
                        );
                        Navigator.pop(context);
                      }
                    },
                  )
                ],
              ),
            );

          } else {
            print('error with snapshot in tracker form');
            return Loading();
          }
        }
      ),
    );
  }
}
