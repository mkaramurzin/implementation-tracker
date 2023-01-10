import 'package:flutter/material.dart';
import 'package:tracker/widgets/custom_slider_thumb_circle.dart';

class Tracker extends StatefulWidget {
  double maxSteps;
  double currentStep;
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
    super.initState();
    deleteOption = false;
    deleteButton = SizedBox(height: 30, width: 56);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 50, 25),
      child: Column(
        children: [
          deleteButton,
          Container(
            height: widget.maxSteps * 73,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                thumbShape: CustomSliderThumbCircle(thumbRadius: 20, name: widget.name),
                thumbColor: Colors.blue,
              ),
              child: RotatedBox(
                quarterTurns: 3,
                child: Slider(
                  value: widget.currentStep,
                  min: 1,
                  max: widget.maxSteps,
                  divisions: (widget.maxSteps as int)-1,
                  onChanged: (value) {
                    setState(() {
                      widget.currentStep = (value).round() as double;
                      if(widget.currentStep == widget.maxSteps) {
                        deleteButton = ElevatedButton(
                          onPressed: widget.delete,
                          child: Icon(Icons.delete),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        );
                      } else {
                        deleteButton = SizedBox(height: 30, width: 56);
                      }
                    });
                  },
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}
