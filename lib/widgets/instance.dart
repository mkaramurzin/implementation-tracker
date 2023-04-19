import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/services/database.dart';
import 'package:tracker/services/extension.dart';
import 'package:tracker/services/themes.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/tracker_form.dart';
import 'package:tracker/widgets/trackers/default.dart';
import 'package:tracker/widgets/trackers/active.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

import '../services/auth.dart';

class Instance extends StatefulWidget {
  String name;
  List<String> descriptions = [];
  int rowMax;
  Instance({required this.name, super.key, this.rowMax = 8});

  @override
  State<Instance> createState() => _InstanceState();
}

class _InstanceState extends State<Instance> {

  int largestRow = 0;
  List<List<Tracker>> trackerMatrix = [[]];
  List<List<List<String>>> trackers = [];
  List<String> descriptions = [];
  Widget implement = Container();
  String path = "";
  final AuthService _auth = AuthService();

  void updateMatrix() {
    trackerMatrix = [[]];
    for(int i = 0; i < trackers.length; i++) {
      List<Tracker> row = [];
      for(int j = 0; j < trackers[i].length; j++) {
        if(trackers[i][j].isNotEmpty) {
          row.add(
            Tracker(
              name: trackers[i][j][0],
              widget: i == trackers.length-1 ?
              Active(
                  name: trackers[i][j][0],
                  color: trackers[i][j][1],
                  backgroundColor: trackers[i][j][2],
                  delete: true,
                  usePopup: trackers[i][j][3] == 'Note' ? true : false,
                  content: trackers[i][j][4],
                  deleteButton: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: ThemeManager().deleteButton),
                    child: Icon(Icons.delete),
                    onPressed: () async {
                      trackers[i].remove(trackers[i][j]);
                      await Database(uid: _auth.user!.uid).updateUserData(
                        widget.name,
                        trackers,
                        descriptions,
                        path,
                      );
                      setState(() {
                        updateMatrix();
                      });
                    },
                  )
              )
              :
              Active(
                name: trackers[i][j][0],
                color: trackers[i][j][1],
                backgroundColor: trackers[i][j][2],
                deleteButton: Container(),
                usePopup: trackers[i][j][3] == 'Note' ? true : false,
                content: trackers[i][j][4],
              )
            )
          );
        }
      }
      row.add(
          Tracker(name: "", widget: Default(
              delete: i == trackers.length-1,
              onAccept: (data) async {
                setState(() {
                  for (var i = trackers.length - 1; i >= 0; i--) {
                    final row = trackers[i];
                    for (var j = row.length - 1; j >= 0; j--) {
                      final subList = row[j];
                      if (subList[0] == data[0]) {
                        row.removeAt(j);
                      }
                    }
                  }

                });
                trackers[i].add(data);
                await Database(uid: _auth.user!.uid).updateUserData(
                  widget.name,
                  trackers,
                  descriptions,
                  path
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

  void menuOption(int option) async {
    switch(option) {
      case 0:
        showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
          return TrackerForm(path: path);
        });
        break;

      case 1:
        Navigator.pushReplacementNamed(context, '/edit', arguments: {
          'widget': this.widget,
          'path': path,
        });
        break;

      case 2:
        await _auth.signOut();
        Navigator.pushReplacementNamed(context, '/');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {

    final data = Provider.of<List<TrackerData?>?>(context) ?? [];
    for(var tracker in data) {
      if(tracker!.name == widget.name) {
        descriptions = tracker.descriptions;
        widget.descriptions = descriptions;
        trackers = tracker.trackerMatrix;
        implement = ImplementationSteps(descriptions: descriptions, totalSteps: descriptions.length);
        path = tracker.path;
        break;
      }
    }
    updateMatrix();

    return Scaffold(
      backgroundColor: ThemeManager().scaffoldColor,
      appBar: AppBar(
        elevation: 5,
        shadowColor: ThemeManager().buttonAccent,
        backgroundColor: ThemeManager().appBarColor,
        title: Text("Implementation Tracker", style: TextStyle(color: ThemeManager().primaryColor)),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            color: ThemeManager().popupPrimary,
            icon: Icon(Icons.settings, color: ThemeManager().primaryColor),
            onSelected: (item) {
              menuOption(item);
              setState(() {

              });
            },
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text("Add Tracker", style: TextStyle(color: ThemeManager().text)),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Edit Steps", style: TextStyle(color: ThemeManager().text)),
              ),
              PopupMenuItem(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        ThemeManager().theme = "classic";
                        setState(() {

                        });
                        await Database(uid: _auth.user!.uid).changeTheme("classic");
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: "#FFA611".toColor()
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        ThemeManager().theme = "kenneth";
                        setState(() {

                        });
                        await Database(uid: _auth.user!.uid).changeTheme("kenneth");
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.deepPurple[900],
                        ),
                      ),
                    )
                  ],
                )
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 2,
                child: Text("Sign Out", style: TextStyle(color: ThemeManager().text)),
              ),
            ],
          )
        ],
      ),
      body: Center(
        child: Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            height: 260 + (descriptions.length * 65),
            width: double.infinity,
            child: ListView(
                children: [Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
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
                            child: implement,
                          )
                        ],
                      ),
                    ),
                  ],
                ),]
            )
        ),
      ),
    );
  }
}
