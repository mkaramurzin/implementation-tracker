import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/services/database.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/trackers/default.dart';
import 'package:tracker/widgets/trackers/active.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/auth.dart';

class Instance extends StatefulWidget {
  late Widget implement;
  List<String> descriptions;
  int rowMax;
  Instance({super.key, required this.descriptions, this.rowMax = 8});

  @override
  State<Instance> createState() => _InstanceState();
}

class _InstanceState extends State<Instance> {

  int largestRow = 0;
  List<List<Tracker>> trackerMatrix = [[]];
  List<List<String>> names = [];
  List<String> descriptions = [];
  bool _isInit = false;
  final AuthService _auth = AuthService();

  void updateMatrix() {
    trackerMatrix = [[]];
    for(int i = 0; i < names.length; i++) {
      List<Tracker> row = [];
      for(int j = 0; j < names[i].length; j++) {
        if(names[i][j].isNotEmpty) {
          row.add(
            Tracker(
              name: names[i][j],
              widget: i == names.length-1 ?
              Active(
                  name: names[i][j],
                  delete: true,
                  deleteButton: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Icon(Icons.delete),
                    onPressed: () async {
                      names[i].remove(names[i][j]);
                      await Database(uid: _auth.user!.uid).updateUserData(
                        names,
                        descriptions,
                      );
                      setState(() {
                        updateMatrix();
                      });
                    },
                  )
              )
              :
              Active(
                name: names[i][j],
                deleteButton: Container(),
              )
            )
          );
        }
      }
      row.add(
          Tracker(name: "", widget: Default(
              delete: i == names.length-1,
              onAccept: (data) async {
                setState(() {
                  names.forEach((subList) {
                    subList.removeWhere((name) => name == data);
                  });
                });
                names[i].add(data);
                await Database(uid: _auth.user!.uid).updateUserData(
                  names,
                  descriptions
                );
                updateMatrix();
              },
          ))
      );
      trackerMatrix.add(row);
    }
    fillRows();

  }

  void fillRows() {
    trackerMatrix.forEach((sublist) {
      sublist.removeWhere((element) => element.fill);
    });
    trackerMatrix.forEach((sublist) {
      while(sublist.length < widget.rowMax) {
        sublist.add(Tracker(fill: true, name: "", widget: Container(width: 67, height: 1)));
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // await Database(uid: _auth.user!.uid).
  }

  @override
  Widget build(BuildContext context) {

    final data = Provider.of<TrackerData?>(context);

    if(!_isInit) {
      descriptions = data!.descriptions;
      widget.implement = ImplementationSteps(totalSteps: descriptions.length, descriptions: descriptions,);
      _isInit = true;
    }
    names = data!.trackerMatrix;
    updateMatrix();


    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: 260 + (descriptions.length * 65),
        color: Colors.green[50],
        width: double.infinity,
        child: ListView(
            children: [Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  color: Colors.blue[50],
                  margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.red[50],
                        margin: EdgeInsets.fromLTRB(0,0,0,10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: trackerMatrix.reversed.map((sublist) => Row(
                                children: sublist.reversed.map((tracker) => tracker.widget).toList()
                            )
                            ).toList()
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 50, 0, 10),
                        child: widget.implement,
                      )
                    ],
                  ),
                ),
              ],
            ),]
        )
    );
  }
}
