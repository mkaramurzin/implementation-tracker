import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/widgets/implementation_steps.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int steps = 10;
  late Widget implement;
  List<String> trackerList = [];

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
                              trackerList.add(_textController.text);
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
    trackerList.add("tracker 1");
    trackerList.add("tracker 2");
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.from(trackerList.reversed).map((e) => Tracker(
                    name: e,
                    maxSteps: steps,
                    delete: () {
                      setState(() {
                        trackerList.remove(e);
                      });
                    },
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
