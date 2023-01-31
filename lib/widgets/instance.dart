import 'package:flutter/material.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/trackers/default.dart';
import 'package:tracker/widgets/trackers/active.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class Instance extends StatefulWidget {
  late Widget implement;
  List<List<Tracker>> trackerMatrix;
  List<String> descriptions;
  int rowMax;
  Instance({super.key, required this.descriptions, required this.trackerMatrix, this.rowMax = 8});

  @override
  State<Instance> createState() => _InstanceState();
}

class _InstanceState extends State<Instance> {

  int largestRow = 0;
  List<List<String>> names = [];
  bool _isInit = false;

  void updateMatrix() {
    widget.trackerMatrix = [[]];
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
                  maxStep: widget.descriptions.length - 1,
                  delete: true,
                  deleteButton: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        names[i].remove(names[i][j]);
                        updateMatrix();
                      });
                    },
                  )
              )
              :
              Active(
                name: names[i][j],
                deleteButton: Container(),
                maxStep: widget.descriptions.length - 1,
              )
            )
          );
        }
      }
      row.add(
          Tracker(name: "", widget: Default(
              delete: i == names.length-1,
              onAccept: (data) {
                setState(() {
                  names.forEach((subList) {
                    subList.removeWhere((name) => name == data);
                  });
                });
                names[i].add(data);
                updateMatrix();
              },
          ))
      );
      widget.trackerMatrix.add(row);
    }
    fillRows();
  }

  void fillRows() {
    widget.trackerMatrix.forEach((sublist) {
      sublist.removeWhere((element) => element.fill);
    });
    widget.trackerMatrix.forEach((sublist) {
      while(sublist.length < widget.rowMax) {
        sublist.add(Tracker(fill: true, name: "", widget: Container(width: 67, height: 1)));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    widget.descriptions = widget.descriptions.isEmpty ?
    List.generate(widget.descriptions.length.toInt(), (index) => "Step $index")
        :
    widget.descriptions;
    widget.implement = ImplementationSteps(totalSteps: widget.descriptions.length, descriptions: widget.descriptions,);
    updateMatrix();
  }

  @override
  Widget build(BuildContext context) {

    if(!_isInit) {
      final data = Provider.of<QuerySnapshot?>(context);
      List dataMap = data!.docs.toList();
      var decodedMatrix = jsonDecode(dataMap[0].get('list'));
      List<List<String>> newList = List<List<String>>.from(decodedMatrix.map((row){
        return List<String>.from(row.map((value) => (value.toString())));
      }));
      print(names);
      print(newList);
      names = newList;
      updateMatrix();
      // print(data.docs);
      // for(var doc in data.docs) {
      //   print(doc.data());
      // }
      _isInit = true;
    }

    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
        height: 260 + (widget.descriptions.length * 65),
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
                            children: widget.trackerMatrix.reversed.map((sublist) => Row(
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
