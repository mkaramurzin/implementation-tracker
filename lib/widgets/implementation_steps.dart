import 'package:flutter/material.dart';

class ImplementationSteps extends StatefulWidget {
  double totalSteps;
  List<String> descriptions;
  ImplementationSteps({super.key, this.totalSteps = 3, required this.descriptions});

  @override
  State<ImplementationSteps> createState() => _ImplementationStepsState();
}

class _ImplementationStepsState extends State<ImplementationSteps> {

  int selectedIndex = -1;
  String description = "";

  late Map<int, String> descList;

  void retrieveDescription() {
    if(selectedIndex == -1) {
      description = "";
    } else {
      description = widget.descriptions[selectedIndex];
    }
  }

  @override
  void initState() {
    super.initState();
    descList =
        Map.fromEntries(widget.descriptions.asMap().entries.toList().reversed);
    retrieveDescription();
  }

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [
        Container(
          height: widget.totalSteps * 72,
          width: 50,
          color: Colors.grey[300],
          child: Column(
            children: descList.entries.map((entry) => Segment(
              last: entry.key == 0,
              tap: () {
                setState(() {
                  if(entry.key == selectedIndex) {
                    selectedIndex = -1;
                  } else {
                    selectedIndex = entry.key;
                  }
                  retrieveDescription();
                });
              },
            )).toList()
          ),
        ),
        Visibility(
          visible: true,
          child: AnimatedContainer(
            margin: EdgeInsets.fromLTRB(50, 0, 0, 0),
            height: description == "" ? 0 : 100,
            width: description == "" ? 0 : 100,
            duration: Duration(milliseconds: 250),
            color: Colors.blue,
            child: Center(child: Text(description)),
          ),
        )
      ],
    );
  }
}

class Segment extends StatelessWidget {
  final bool last;
  final Function() tap;
  const Segment({super.key, required this.last, required this.tap});

  @override
  Widget build(BuildContext context) {
    Widget widget = last ?
    GestureDetector(
      onTap: tap,
      child: Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
      ),
    )
    :
    Column(
      children: [
        GestureDetector(
          onTap: tap,
          child: Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
        ),
        Container(
          height: 30,
          width: 10,
          color: Colors.black,
        )
      ],
    );

    return widget;
  }
}
