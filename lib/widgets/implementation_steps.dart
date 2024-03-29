import 'package:flutter/material.dart';
import 'package:tracker/services/extension.dart';
import 'package:tracker/services/themes.dart';

class ImplementationSteps extends StatefulWidget {
  int totalSteps;
  List<String> descriptions;
  bool editing;
  Function(int index) insertArray;
  Function(int index) removeArray;
  Function(int dummy) clearMatrix;
  ImplementationSteps({
    super.key,
    this.totalSteps = 1,
    required this.descriptions,
    this.editing = false,
    this.insertArray = _dummyFunction,
    this.removeArray = _dummyFunction,
    this.clearMatrix = _dummyFunction,
  });

  static void _dummyFunction(int index) {
    // Do nothing
  }

  @override
  State<ImplementationSteps> createState() => _ImplementationStepsState();
}

class _ImplementationStepsState extends State<ImplementationSteps> {

  int selectedIndex = -1;
  String description = "";
  final _controller = TextEditingController();

  Map<int, String> descList = {};

  void buildMap() {
    if(widget.descriptions.length == 0) {
      widget.descriptions.add("Step 1 here");
    }
    widget.totalSteps - widget.descriptions.length;
    descList =
        Map.fromEntries(widget.descriptions.asMap().entries.toList().reversed);
  }

  @override
  void initState() {
    super.initState();
    buildMap();
    description = descList[0]!;
    selectedIndex = widget.editing ? -1 : 0;
  }

  @override
  Widget build(BuildContext context) {
    double multiplier = widget.descriptions.length < 6 ? 72 : 73;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.editing ?
        AnimatedContainer(
          duration: Duration(seconds: 1),
          margin: EdgeInsets.all(40),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  widget.descriptions.clear();
                  widget.totalSteps = 1;
                  widget.clearMatrix(0);
                  setState(() {
                    buildMap();
                  });
                  selectedIndex = 0;
                  description = widget.descriptions[selectedIndex];
                  _controller.text = description;
                  _controller.notifyListeners();
                },
                style: ElevatedButton.styleFrom(backgroundColor: ThemeManager().primaryColor),
                child: Text('Clear', style: TextStyle(color: ThemeManager().buttonSecondary)),
              ),
            ],
          ),
        )
            :
        Container(),
        Row(
          crossAxisAlignment: widget.descriptions.length > 3 ?
          CrossAxisAlignment.center : CrossAxisAlignment.end,
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: widget.totalSteps * (widget.editing ? 85 : multiplier),
              width: widget.editing ? 150 : 50,
              child: Column(
                  children: descList.entries.map((entry) => Segment(
                    connector: widget.editing ?
                    GestureDetector(
                      onTap: () {
                        widget.descriptions.insert(entry.key + 1, "New step description");
                        widget.insertArray(entry.key + 1);
                        buildMap();
                        setState(() {
                          selectedIndex = entry.key + 1;
                          description = widget.descriptions[selectedIndex];
                          widget.totalSteps++;
                          _controller.text = description;
                          _controller.notifyListeners();
                        });
                      },
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Container(
                          margin: EdgeInsets.all(5),
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: ThemeManager().buttonSecondary,
                            border: Border.all(
                              color: ThemeManager().buttonPrimary!,
                              width: 2.0,
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.add,
                              color: ThemeManager().buttonPrimary,
                            ),
                          ),
                        ),
                      ),
                    )
                        :
                    entry.key == descList.length-1 ?
                    Container()
                        :
                    Container(
                      height: 30,
                      width: 10,
                      color: Colors.black,
                    ),
                    deleteButton: widget.editing ?
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeManager().buttonPrimary,
                        ),
                        onPressed: () {
                          widget.removeArray(widget.descriptions.indexOf(entry.value));
                          widget.descriptions.remove(entry.value);
                          buildMap();
                          setState(() {
                            if(widget.totalSteps > 1) {
                              widget.totalSteps--;
                            }
                            selectedIndex = -1;
                            description = "";
                          });
                          _controller.text = description;
                          _controller.notifyListeners();
                        },
                        child: Icon(Icons.delete),
                      ),
                    )
                        :
                    Container(),
                    node: GestureDetector(
                      onTap: () {
                        setState(() {
                          if(entry.key == selectedIndex) {
                            description = "";
                            selectedIndex = -1;
                          } else {
                            selectedIndex = entry.key;
                            description = widget.descriptions[entry.key];
                          }
                          _controller.text = description;
                          _controller.notifyListeners();
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 250),
                        height: 45,
                        width: 45,
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: selectedIndex == entry.key ? ThemeManager().stepPrimary : ThemeManager().stepSecondary,
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                    ),
                  )).toList()
              ),
            ),
            AnimatedContainer(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                height: 200,
                width: 300,
                decoration: BoxDecoration(
                    color: description == "" ? ThemeManager().scaffoldColor : ThemeManager().buttonSecondary, // TODO description box
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: description == "" ?
                    []
                        :
                    [
                      BoxShadow(
                        color: ThemeManager().stepPrimary!.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ]
                ),
                duration: Duration(milliseconds: 250),
                child: !widget.editing ?
                ListView(
                  children: [
                    Text(description, style: TextStyle(color: ThemeManager().text))
                  ],
                )
                    :
                Visibility(
                  visible: description != "",
                  child: Column(
                    children: [
                      SizedBox(
                        height: 150,
                        child: TextFormField(
                          cursorColor: ThemeManager().stepSecondary,
                          style: TextStyle(color: ThemeManager().text),
                          controller: _controller,
                          maxLines: 10,
                          readOnly: description == "",
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                              enabled: description != ""
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeManager().buttonPrimary,
                        ),
                        onPressed: () {
                          widget.descriptions[selectedIndex] = _controller.text;
                          buildMap();
                          setState(() {
                            description = "";
                            selectedIndex = -1;
                          });
                        },
                        child: Text('Save'),
                      )
                    ],
                  ),
                )
            )
          ],
        ),
      ],
    );
  }
}

class Segment extends StatelessWidget {
  final Widget node;
  final Widget deleteButton;
  final Widget connector;
  const Segment(
      {super.key, required this.connector, required this.node,
        required this.deleteButton});

  @override
  Widget build(BuildContext context) {
    Widget widget =
    Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        deleteButton,
        Column(
          children: [
            connector,
            node,
          ],
        ),
      ],
    );

    return widget;
  }
}
