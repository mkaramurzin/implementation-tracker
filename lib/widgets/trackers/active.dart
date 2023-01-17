import 'package:flutter/material.dart';
import 'package:tracker/widgets/tracker.dart';

class Active extends StatelessWidget {
  Tracker tracker;
  Widget deleteButton;
  double maxStep;
  Active({super.key, required this.tracker, required this.deleteButton, required this.maxStep});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        deleteButton,
        Container(
          margin: EdgeInsets.fromLTRB(7, 5, 10, (tracker.currentStep == maxStep ? 17 : tracker.currentStep*1.6)),
          child: Draggable<Tracker>(
            data: tracker,
            feedback: CircleAvatar(
              backgroundColor: Colors.red,
              radius: 25,
              child: Center(child: Text(tracker.name)),
            ),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              radius: 25,
              child: Center(child: Text(tracker.name)),
            ),
          ),
        ),
      ],
    );
  }
}
