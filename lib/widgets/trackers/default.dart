import 'package:flutter/material.dart';
import 'package:tracker/widgets/tracker.dart';

class Default extends StatelessWidget {
  Function(Tracker data) onAccept;
  Function(String data) onWillAccept;
  Default({super.key, required this.onAccept, required this.onWillAccept});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: DragTarget<Tracker>(
          builder: (context, accepted, rejected) {
            return Container(
              color: Colors.green,
              height: 74,
              width: 72,
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: this.onAccept
      ),
    );
  }
}