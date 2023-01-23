import 'package:flutter/material.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/trackers/default.dart';
import 'package:tracker/widgets/trackers/active.dart';

class Instance extends StatefulWidget {
  late Widget implement;
  List<List<Tracker>> trackerMatrix;
  List<String> descriptions;
  int rowMax;
  Instance({super.key, required this.descriptions, required this.trackerMatrix, this.rowMax = 11});

  @override
  State<Instance> createState() => _InstanceState();
}

class _InstanceState extends State<Instance> {

  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void menuOption(int option) {
    switch(option) {
      case 0:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Add Tracker"),
                  content: Container(
                    height: 150,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _textController,
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: 'Tracker Name'
                            ),
                            validator: (text) {
                              if(_textController.text.isEmpty) {
                                return "Please name the tracker";
                              } else if(widget.trackerMatrix.any((sublist) => sublist.where((tracker) => tracker.name == _textController.text).isNotEmpty)) {
                                return "Tracker with that name already exists";
                              }
                              // else if(trackerMatrix[0].where((element) => element.fill == false).length == rowMax) {
                              //   return "The bottom row cannot hold anymore trackers";
                              // }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text("Add"),
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                setState(() {
                                  for(int i = 0; i < widget.trackerMatrix[0].length; i++) {
                                    if(widget.trackerMatrix[0][i].name == "") {
                                      widget.trackerMatrix[0].add(Tracker(
                                          name: _textController.text,
                                          widget: Container()
                                      ));
                                      break;
                                    }
                                  }
                                  // trackerMatrix[0].add(Tracker(name: _textController.text, widget: Container()));
                                  _textController.text = "";
                                  updateMatrix();
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(context, '/edit', arguments: {
          'widget': widget
        });
    }
  }

  void updateMatrix() {
    for(int i = 0; i < widget.trackerMatrix.length; i++) {
      widget.trackerMatrix[i].sort((a, b) {
        if (a.name.isEmpty && !b.name.isEmpty) {
          return 1;
        }
        if (!a.name.isEmpty && b.name.isEmpty) {
          return -1;
        }
        return 0;
      });
      for(int j = 0; j < widget.trackerMatrix[i].length; j++) {
        if(widget.trackerMatrix[i][j].name != "") {
          widget.trackerMatrix[i][j].currentStep = i.toDouble();
          widget.trackerMatrix[i][j].widget =
          widget.trackerMatrix[i][j].currentStep != widget.descriptions.length - 1 ?
          Active(
            tracker: widget.trackerMatrix[i][j],
            deleteButton: Container(),
            maxStep: widget.descriptions.length - 1,
          )
              :
          Active(
              tracker: widget.trackerMatrix[i][j],
              maxStep: widget.descriptions.length - 1,
              deleteButton: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    widget.trackerMatrix[widget.descriptions.length.toInt()-1].remove(widget.trackerMatrix[i][j]);
                    updateMatrix();
                  });
                },
              )
          );
        }
      }
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
    widget.trackerMatrix =
        List.generate(widget.descriptions.length, (i) => List.generate(1, (j) => Tracker(name: "", widget: Default(
            onAccept: (data) {
              setState(() {
                widget.trackerMatrix.forEach((subList) {
                  subList.removeWhere((e) => e.name == data.name);
                });
              });
              widget.trackerMatrix[i].add(data);
              updateMatrix();
            },
            onWillAccept: (data) {
              return true;
            }
        ))));
    widget.descriptions = widget.descriptions.isEmpty ?
        List.generate(widget.descriptions.length.toInt(), (index) => "Step $index")
    :
        widget.descriptions;
    widget.implement = ImplementationSteps(totalSteps: widget.descriptions.length, descriptions: widget.descriptions,);
    Tracker t1 = Tracker(name: "T1", currentStep: 0, widget: Container());
    Tracker t2 = Tracker(name: "T2", currentStep: 0, widget: Container());
    widget.trackerMatrix[t1.currentStep.toInt()].add(t1);
    widget.trackerMatrix[t2.currentStep.toInt()].add(t2);
    updateMatrix();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Implementation Tracker"),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            onSelected: (item) {
              menuOption(item);
            },
            position: PopupMenuPosition.under,
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0,
                child: Text("Add Tracker"),
              ),
              PopupMenuItem(
                value: 1,
                child: Text("Edit Steps"),
              ),
              PopupMenuDivider(),
              PopupMenuItem(
                value: 2,
                child: Text("Sign Out"),
              ),
            ],
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.fromLTRB(0, 50, 0, 0),
          height: 2000,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.fromLTRB(0,0,0,0),
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
                ),
              ],
            ),
          )
      ),
    );
  }
}
