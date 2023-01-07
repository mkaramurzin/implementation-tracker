import 'package:flutter/material.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:steps_indicator/steps_indicator.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  double _step = 0;
  double _step2 = 1;

  Widget w1 = StepsIndicator(
    selectedStep: 15,
    nbSteps: 16,
    lineLength: 50,
    doneLineThickness: 2,
    undoneLineThickness: 2,
    selectedStepSize: 25,
    unselectedStepSize: 25,
    doneStepSize: 25,
  );

  Widget w2 = StepProgressIndicator(
    totalSteps: 16,
    currentStep: 15,
    size: 36,
    selectedColor: Colors.black,
    unselectedColor: Colors.grey,
    customStep: (index, color, _) => color == Colors.black
        ? Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color
        )
    )
        : Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color
      ),
    ),
  );

  Widget w3 = StepsIndicator(
    isHorizontal: false,
    selectedStep: 15,
    nbSteps: 16,
    lineLength: 50,
    doneLineThickness: 2,
    undoneLineThickness: 2,
    selectedStepSize: 25,
    unselectedStepSize: 25,
    doneStepSize: 25,
    // doneStepWidget: Container(
    //   height: 20,
    //   width: 20,
    //   decoration: BoxDecoration(
    //     shape: BoxShape.rectangle,
    //     color: Colors.red
    //   ),
    // ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: w1,
            ),
            SizedBox(height: 20),
            Text('MYK', textAlign: TextAlign.left),
            Container(
              width: 1175,
              child: Slider(
                label: 'MYK',
                value: _step,
                divisions: 15,
                onChanged: (newValue) {
                  setState(() {
                    _step = newValue;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(50),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(width: 450),
                      Text('MYK')
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 15, 25, 0),
                        child: Column(
                          children: [
                            Text('Review customer sign up form and statement of work.'),
                            SizedBox(height: 55),
                            Text('New Project Request for full setup')
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 12, 0, 0),
                        child: w3
                      ),
                      SizedBox(width: 50),
                      Container(
                        height: 1175,
                        child: SfSlider.vertical(
                          min: 1,
                          max: 16,
                          showTicks: true,
                          isInversed: true,
                          showLabels: true,
                          interval: 1,
                          thumbIcon: Icon(Icons.account_balance),
                          value: _step2,
                          onChanged: (value) {
                            setState(() {
                              _step2 = (value).round();
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),]
      ),
    );
  }
}
