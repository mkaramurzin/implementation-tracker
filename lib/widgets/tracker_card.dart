import 'package:flutter/material.dart';

class TrackerCard extends StatefulWidget {
  String name;
  double currentStep;
  Widget theWidget;
  TrackerCard({super.key, required this.name, required this.currentStep, required this.theWidget});

  @override
  State<TrackerCard> createState() => _TrackerCardState();
}

class _TrackerCardState extends State<TrackerCard> {

  // @override
  // void initState() {
  //   super.initState();
  //   theWidget = widget.name != "" ?
  //   Container(
  //     margin: EdgeInsets.fromLTRB(0, 20, 15, 5),
  //     child: Draggable(
  //       data: widget.name,
  //       feedback: CircleAvatar(
  //         backgroundColor: Colors.red,
  //         radius: 25,
  //         child: Center(child: Text(widget.name)),
  //       ),
  //       child: CircleAvatar(
  //         backgroundColor: Colors.black,
  //         radius: 25,
  //         child: Center(child: Text(widget.name)),
  //       ),
  //     ),
  //   )
  //       : // else
  //   DragTarget(
  //     builder: (context, acceptedData, rejectedData) {
  //       return Container(
  //         margin: EdgeInsets.fromLTRB(0, 20, 15, 5),
  //         child: CircleAvatar(
  //           backgroundColor: Colors.black,
  //           radius: 25,
  //           child: Center(child: Text(widget.name)),
  //         ),
  //       );
  //     },
  //     onWillAccept: (data) {
  //       return true;
  //     },
  //     onAccept: (data) {
  //       widget.name = data.toString();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {

    return widget.theWidget;
  }
}

