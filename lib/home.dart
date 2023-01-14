import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/custom_slider_thumb_circle.dart';
import 'package:tracker/widgets/tracker_card.dart';
import 'package:tracker/widgets/trackers/default.dart';
import 'package:tracker/widgets/trackers/active.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double steps = 10;
  late Widget implement;
  late List<List<Tracker>> trackerMatrix;
  List<String> descriptions = [];

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
                          } else if(trackerMatrix.any((sublist) => sublist.where((tracker) => tracker.name == _textController.text).isNotEmpty)) {
                            return "Tracker with that name already exists";
                          } else if(trackerMatrix[0].every((t) => t.name != "")) {
                            return "The bottom row cannot hold anymore trackers";
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        child: Text("Add"),
                        onPressed: () {
                          if(_formKey.currentState!.validate()) {
                            setState(() {
                              for(int i = 0; i < trackerMatrix[0].length; i++) {
                                if(trackerMatrix[0][i].name == "") {
                                  trackerMatrix[0][i] = Tracker(
                                    name: _textController.text,
                                    widget: Container()
                                  );
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

    }
  }

  void updateMatrix() {
    for(int i = 0; i < trackerMatrix.length; i++) {
      bool firstEmpty = true;
      trackerMatrix[i].sort((a, b) {
        if (a.name.isEmpty && !b.name.isEmpty) {
          return 1;
        }
        if (!a.name.isEmpty && b.name.isEmpty) {
          return -1;
        }
        return 0;
      });
      for(int j = 0; j < trackerMatrix[i].length; j++) {
        if(trackerMatrix[i][j].name != "") {
          trackerMatrix[i][j].currentStep = i.toDouble();
          trackerMatrix[i][j].widget = trackerMatrix[i][j].currentStep != steps-1?
              Active(
                tracker: trackerMatrix[i][j],
                deleteButton: Container(),
                maxStep: steps-1,
              )
          :
              Active(
                tracker: trackerMatrix[i][j],
                maxStep: steps-1,
                deleteButton: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      trackerMatrix[i][j].name = "";
                      updateMatrix();
                    });
                  },
                )
              );
        } else if(firstEmpty){
          firstEmpty = false;
          trackerMatrix[i][j].widget = Default(
              onAccept: (data) {
                setState(() {
                  trackerMatrix.forEach((subList) {
                    subList.forEach((e) {
                      if(e.name == data.name) {
                        e.name = "";
                        updateMatrix();
                      }
                    });
                  });
                });
                trackerMatrix[i][j].name = data.name;
                updateMatrix();
              },
              onWillAccept: (data) {
                return true;
              }
          );
        } else {
          trackerMatrix[i][j].widget = Container();
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    trackerMatrix =
    List.generate(steps.toInt(), (_) => List.generate(10, (_) => Tracker(name: "", widget: Container())));
    descriptions =
    List.generate(steps.toInt(), (index) => "$index");
    implement = ImplementationSteps(totalSteps: steps, descriptions: descriptions,);
    Tracker t1 = Tracker(name: "T1", currentStep: 0, widget: Container());
    Tracker t2 = Tracker(name: "T2", currentStep: 0, widget: Container());
    trackerMatrix[t1.currentStep.toInt()][0] = t1;
    trackerMatrix[t2.currentStep.toInt()][1] = t2;
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
        margin: EdgeInsets.fromLTRB(200, 50, 50, 50),
        height: 2000,
        child: ListView(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    margin: EdgeInsets.fromLTRB(0,0,0,0),
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
            )
          ],
        ),
      ),
    );
  }
}
