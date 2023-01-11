import 'package:flutter/material.dart';

class TrackerCard extends StatelessWidget {
  String name;
  double currentStep;
  TrackerCard({super.key, required this.name, required this.currentStep});

  @override
  Widget build(BuildContext context) {

    Widget widget = name != "" ?
    Container(
      margin: EdgeInsets.fromLTRB(0, 20, 15, 5),
      child: Draggable(
        data: name,
        feedback: CircleAvatar(
          backgroundColor: Colors.red,
          radius: 25,
          child: Center(child: Text(name)),
        ),
        child: CircleAvatar(
          backgroundColor: Colors.black,
          radius: 25,
          child: Center(child: Text(name)),
        ),
      ),
    )
        : // else
    DragTarget(
      builder: (context, acceptedData, rejectedData) {
        return Container(
          margin: EdgeInsets.fromLTRB(0, 20, 15, 5),
          child: CircleAvatar(
            backgroundColor: Colors.black,
            radius: 25,
            child: Center(child: Text(name)),
          ),
        );
      },
      onWillAccept: (data) {
        return true;
      },
      onAccept: (data) {

      },
    );
    return widget;
  }
}
