import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Tracker extends StatefulWidget {
  int maxSteps;
  int currentStep;
  String name;
  Tracker({super.key, this.maxSteps = 2, this.currentStep = 1, required this.name});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.name),
        SizedBox(width: 50),
        Container(
          height: widget.maxSteps * 73,
          child: SfSlider.vertical(
            min: 1,
            max: widget.maxSteps,
            showTicks: true,
            showLabels: true,
            interval: 1,
            // thumbIcon: Icon(Icons.account_balance),
            value: widget.currentStep,
            onChanged: (value) {
              setState(() {
                widget.currentStep = (value).round();
              });
            },
          ),
        ),
        SizedBox(width: 50),
        Text(widget.name)
      ],
    );
  }
}
