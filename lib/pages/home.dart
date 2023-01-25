import 'package:flutter/material.dart';
import 'package:tracker/widgets/instance.dart';
import 'package:tracker/widgets/tracker.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<Instance> tabs = [];
  late Instance instance;
  Map data = {};
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void menuOption(int option) {
    switch(option) {
      case 0:
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  title: Text("Add Tracker"),
                  content: Container(
                    height: 150,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _textController,
                            autofocus: true,
                            decoration: InputDecoration(
                                labelText: 'Tracker Name'
                            ),
                            validator: (text) {
                              if(_textController.text.isEmpty) {
                                return "Please name the tracker";
                              } else if(instance.trackerMatrix.any((sublist) => sublist.where((tracker) => tracker.name == _textController.text).isNotEmpty)) {
                                return "Tracker with that name already exists";
                              }
                              // else if(trackerMatrix[0].where((element) => element.fill == false).length == rowMax) {
                              //   return "The bottom row cannot hold anymore trackers";
                              // }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            child: Text("Add"),
                            onPressed: () {
                              if(_formKey.currentState!.validate()) {
                                setState(() {
                                  for(int i = 0; i < instance.trackerMatrix[0].length; i++) {
                                    if(instance.trackerMatrix[0][i].name == "") {
                                      instance.trackerMatrix[0].add(Tracker(
                                          name: _textController.text,
                                          widget: Container()
                                      ));
                                      break;
                                    }
                                  }
                                  // trackerMatrix[0].add(Tracker(name: _textController.text, widget: Container()));
                                  _textController.text = "";
                                  // updateMatrix();
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  )
              );
            }
        );
        break;

      case 1:
        Navigator.pushReplacementNamed(context, '/edit', arguments: {
          'widget': instance
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('build');
    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;

    instance = data['widget'];
    tabs.add(instance);

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Implementation Tracker"),
          centerTitle: true,
          actions: [
            PopupMenuButton<int>(
              onSelected: (item) {
                menuOption(item);
                setState(() {

                });
              },
              position: PopupMenuPosition.under,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 0,
                  child: Text("Add Tracker"),
                ),
                PopupMenuItem(
                  value: 1,
                  child: Text("Edit Steps"),
                ),
                PopupMenuDivider(),
                PopupMenuItem(
                  value: 2,
                  child: Text("Sign Out"),
                ),
              ],
            )
          ],
        ),
        body: Center(child: instance),
        bottomNavigationBar: Material(
          color: Colors.blue,
          child: TabBar(
            isScrollable: true,
            tabs: tabs.map((title) {
              return Tab(text: 'tab');
            }).toList(),
          ),
        ),
      ),
    );
  }
}

