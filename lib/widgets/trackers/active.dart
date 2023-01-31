import 'package:flutter/material.dart';

class Active extends StatelessWidget {
  String name;
  Widget deleteButton;
  double maxStep;
  bool delete;
  Active({super.key, required this.name, required this.deleteButton, required this.maxStep, this.delete = false});

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        deleteButton,
        Container(
          margin: EdgeInsets.fromLTRB(7, 5, 10, (delete ? 17 : 10)),
          child: Draggable<String>(
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
        ),
      ],
    );
  }
}
