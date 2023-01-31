import 'package:flutter/material.dart';

class Default extends StatelessWidget {
  Function(String data) onAccept;
  bool delete;
  Default({super.key, required this.onAccept, this.delete = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, (delete ? 26 : 0), 0, 0),
      child: DragTarget<String>(
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