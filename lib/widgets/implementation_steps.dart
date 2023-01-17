import 'package:flutter/material.dart';

class ImplementationSteps extends StatefulWidget {
  double totalSteps;
  List<String> descriptions;
  bool editing;
  ImplementationSteps({super.key, this.totalSteps = 1, required this.descriptions, this.editing = false});

  @override
  State<ImplementationSteps> createState() => _ImplementationStepsState();
}

class _ImplementationStepsState extends State<ImplementationSteps> {

  int selectedIndex = -1;
  String description = "";

  late Map<int, String> descList;

  void buildMap() {
    if(widget.descriptions.length == 0) {
      widget.descriptions.add("Step 1 here");
    }
    descList =
        Map.fromEntries(widget.descriptions.asMap().entries.toList().reversed);
  }

  @override
  void initState() {
    super.initState();
    buildMap();
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.editing ?
        Container(
          margin: EdgeInsets.all(40),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.descriptions.clear();
                  setState(() {
                    buildMap();
                  });
                },
                child: Text('Clear'),
              ),
            ],
          ),
        )
        :
        Container(),
        Row(
          children: [
            Container(
              height: widget.totalSteps * 72,
              width: widget.editing ? 200 : 50,
              child: Column(
                children: descList.entries.map((entry) => Segment(
                  deleteButton: widget.editing ?
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: ElevatedButton(
                      onPressed: () {
                        widget.descriptions.remove(entry.value);
                        buildMap();
                        setState(() {

                        });
                      },
                      child: Icon(Icons.delete),
                    ),
                  )
                  :
                  Container(),
                  first: entry.key == descList.length-1,
                  color: selectedIndex == entry.key ? Colors.blue : Colors.red,
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
        ),
      ],
    );
  }
}

class Segment extends StatelessWidget {
  final bool first;
  final Function() tap;
  final Widget deleteButton;
  final Color color;
  const Segment({super.key, required this.first, required this.tap, required this.deleteButton, this.color = Colors.red});

  @override
  Widget build(BuildContext context) {
    Widget widget = first ?
    Row(
      children: [
        deleteButton,
        GestureDetector(
          onTap: tap,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 250),
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
          ),
        ),
      ],
    )
    :
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        deleteButton,
        Column(
          children: [
            Container(
              height: 30,
              width: 10,
              color: Colors.black,
            ),
            GestureDetector(
              onTap: tap,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: color,
                  borderRadius: BorderRadius.all(Radius.circular(10))
                ),
              ),
            )
          ],
        ),
      ],
    );

    return widget;
  }
}
