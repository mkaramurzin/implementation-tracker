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

  @override
  void initState() {
    super.initState();
    implement = ImplementationSteps(totalSteps: steps);
  }

  Widget w1 = StepsIndicator(
    selectedStep: 15,
    nbSteps: 16,
    lineLength: 50,
    doneLineThickness: 2,
    undoneLineThickness: 2,
    selectedStepSize: 25,
    unselectedStepSize: 25,
    doneStepSize: 25,
  );

  Widget w2 = StepProgressIndicator(
    totalSteps: 16,
    currentStep: 15,
    size: 36,
    selectedColor: Colors.black,
    unselectedColor: Colors.grey,
    customStep: (index, color, _) => color == Colors.black
        ? Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color
        )
    )
        : Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color
      ),
    ),
  );

  Widget w3 = StepsIndicator(
    isHorizontal: false,
    selectedStep: 15,
    nbSteps: 16,
    lineLength: 50,
    doneLineThickness: 2,
    undoneLineThickness: 2,
    selectedStepSize: 25,
    unselectedStepSize: 25,
    doneStepSize: 25,
    // doneStepWidget: Container(
    //   height: 20,
    //   width: 20,
    //   decoration: BoxDecoration(
    //     shape: BoxShape.rectangle,
    //     color: Colors.red
    //   ),
    // ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Tracker(name: 'Tracker 1', maxSteps: steps),
                SizedBox(width: 50),
                Tracker(name: 'Tracker 2', maxSteps: steps),
                SizedBox(width: 50),
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
