import 'package:flutter/material.dart';
import 'package:steps_indicator/steps_indicator.dart';

class ImplementationSteps extends StatelessWidget {
  int totalSteps;
  ImplementationSteps({super.key, this.totalSteps = 2});

  @override
  Widget build(BuildContext context) {
    return StepsIndicator(
      isHorizontal: false,
      selectedStep: 15,
      nbSteps: totalSteps,
      lineLength: 50,
      doneLineThickness: 2,
      undoneLineThickness: 2,
      selectedStepSize: 25,
      unselectedStepSize: 25,
      doneStepSize: 25,
      doneStepWidget: Tooltip(
        message: 'Tooltip',
        child: Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.red
          ),
        ),
      )
    );
  }
}

