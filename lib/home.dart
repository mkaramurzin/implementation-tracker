import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/custom_slider_thumb_circle.dart';
import 'package:tracker/widgets/tracker_card.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double steps = 10;
  late Widget implement;
  List<List<Tracker>> trackerMatrix =
  List.generate(10, (_) => List.generate(10, (_) => Tracker(name: "")));

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
                              trackerMatrix[0].add(Tracker(name: _textController.text));
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
    Tracker t1 = Tracker(name: "T1", currentStep: 0);
    Tracker t2 = Tracker(name: "T2", currentStep: 3);
    trackerMatrix[t1.currentStep.toInt()][0] = t1;
    trackerMatrix[t2.currentStep.toInt()][1] = t2;
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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  children: trackerMatrix.reversed.map((sublist) => Row(
                    children: sublist.reversed.map((tracker) => TrackerCard(
                      name: tracker.name,
                      currentStep: tracker.currentStep,
                    )).toList()
                  )
                  ).toList()
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
