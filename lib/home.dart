import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/tracker_values.dart';
import 'package:tracker/widgets/custom_slider_thumb_circle.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double steps = 10;
  late Widget implement;
  List<TrackerValues> trackerList = [];

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
                          } else if(trackerList.where((tracker) => tracker.name == _textController.text).isNotEmpty) {
                            return "Tracker with that name already exists";
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
                              trackerList.add(TrackerValues(name: _textController.text));
                              _textController.text = "";
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

  @override
  void initState() {
    super.initState();
    implement = ImplementationSteps(totalSteps: steps);
    trackerList.add(TrackerValues(name: "T1"));
    trackerList.add(TrackerValues(name: "T2"));
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
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.from(trackerList.reversed).map((tracker) => Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 50, 25),
                    child: Column(
                      children: [
                        tracker.deleteButton,
                        Container(
                            height: steps * 73,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                thumbShape: CustomSliderThumbCircle(thumbRadius: 20, name: tracker.name),
                                thumbColor: Colors.blue,
                              ),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Slider(
                                  value: tracker.currentStep,
                                  min: 1,
                                  max: steps,
                                  divisions: (steps as int)-1,
                                  onChanged: (value) {
                                    setState(() {
                                      tracker.currentStep = (value).round() as double;
                                      if(tracker.currentStep == steps) {
                                        tracker.deleteButton = ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              trackerList.remove(tracker);
                                            });
                                          },
                                          child: Icon(Icons.delete),
                                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                        );
                                      } else {
                                        tracker.deleteButton = SizedBox(height: 28, width: 56);
                                      }
                                    });
                                  },
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  )).toList()
                ),
                Column(
                  children: [
                    SizedBox(height: 23),
                    implement,
                    SizedBox(height: 20),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
