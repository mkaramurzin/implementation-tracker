import 'package:flutter/material.dart';

class Default extends StatelessWidget {
  Function(List<String> data) onAccept;
  bool delete;
  Default({super.key, required this.onAccept, this.delete = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, (delete ? 26 : 0), 0, 0),
      child: DragTarget<List<String>>(
          builder: (context, accepted, rejected) {
            return Container(
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