import 'package:flutter/material.dart';

class ImplementationSteps extends StatefulWidget {
  int totalSteps;
  List<String> descriptions;
  bool editing;
  ImplementationSteps({super.key, this.totalSteps = 1, required this.descriptions, this.editing = false});

  @override
  State<ImplementationSteps> createState() => _ImplementationStepsState();
}

class _ImplementationStepsState extends State<ImplementationSteps> {

  int selectedIndex = -1;
  String description = "";
  final _controller = TextEditingController();

  late Map<int, String> descList;

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
                  setState(() {
                    buildMap();
                  });
                  selectedIndex = 0;
                  description = widget.descriptions[selectedIndex];
                  _controller.text = description;
                  _controller.notifyListeners();
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: Text('Clear'),
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
            Container(
              color: Colors.yellow[100],
              height: widget.totalSteps * (widget.editing ? 85 : multiplier),
              width: widget.editing ? 150 : 50,
              child: Column(
                  children: descList.entries.map((entry) => Segment(
                    connector: widget.editing ?
                    GestureDetector(
                      onTap: () {
                        widget.descriptions.insert(entry.key + 1, "New step description");
                        buildMap();
                        setState(() {
                          selectedIndex = entry.key + 1;
                          description = widget.descriptions[selectedIndex];
                          widget.totalSteps++;
                          _controller.text = description;
                          _controller.notifyListeners();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Colors.white,
                          border: Border.all(
                            color: Colors.blue,
                            width: 2.0,
                          ),
                        ),
                        child: Center(
                          child: const Icon(
                            Icons.add,
                            color: Colors.blue,
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
                        onPressed: () {
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
                            color: selectedIndex == entry.key ? Colors.blue : Colors.red,
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
                child: !widget.editing ?
                ListView(
                  children: [
                    Text(description)
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
                        onPressed: () {
                          widget.descriptions[selectedIndex] = _controller.text;
                          buildMap();
                          setState(() {

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
