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

  @override
  void initState() {
    super.initState();
    descList =
        Map.fromEntries(widget.descriptions.asMap().entries.toList().reversed);
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
                    description = "";
                    selectedIndex = -1;
                  } else {
                    selectedIndex = entry.key;
                    description = widget.descriptions[entry.key];
                  }
                });
              },
            )).toList()
          ),
        ),
        AnimatedContainer(
          margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          height: 200,
          width: 300,
          decoration: BoxDecoration(
            color: description == "" ? Colors.grey[50] : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: description == "" ?
                  []
              :
              [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ]
          ),
          duration: Duration(milliseconds: 250),
          child: Center(child: Text(description)),
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
