import 'package:flutter/material.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/instance.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late ImplementationSteps implementation;
  late Instance original;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      final Map data = ModalRoute.of(context)!.settings.arguments as Map;
      original = data['widget'];
      List<String> deepCopy = List.from(original.descriptions);
      implementation = ImplementationSteps(
        totalSteps: original.descriptions.length,
        descriptions: deepCopy,
        editing: true,
      );
      _isInit = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Steps"),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(200, 40, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      implementation,
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/home', arguments: {
                                  'widget': original
                                });
                              },
                              child: Text("Cancel"),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(context, '/home', arguments: {
                                  'widget': Instance(descriptions: implementation.descriptions,
                                  trackerMatrix: [[]])
                                });
                              },
                              child: Text("Save"),
                            ),
                          )
                        ],
                      )
                    ]
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}
