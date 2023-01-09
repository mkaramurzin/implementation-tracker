import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Tracker extends StatefulWidget {
  int maxSteps;
  int currentStep;
  String name;
  final Function()? delete;
  Tracker({super.key, this.maxSteps = 2, this.currentStep = 1, required this.name, this.delete});

  @override
  State<Tracker> createState() => _TrackerState();
}

class _TrackerState extends State<Tracker> {

  late bool deleteOption;
  late Widget deleteButton;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deleteOption = false;
    deleteButton = Container();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 50, 0),
      child: Column(
        children: [
          deleteButton,
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
                  if(widget.currentStep == widget.maxSteps) {
                    deleteButton = ElevatedButton(
                      onPressed: widget.delete,
                      child: Text("Delete"),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    );
                  } else {
                    deleteButton = Container();
                  }
                });
              },
            ),
          ),
          SizedBox(width: 50),
          Text(widget.name)
        ],
      ),
    );
  }
}
