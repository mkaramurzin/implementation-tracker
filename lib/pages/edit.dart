import 'package:flutter/material.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/services/extension.dart';
import 'package:tracker/services/themes.dart';
import 'package:tracker/widgets/implementation_steps.dart';
import 'package:tracker/widgets/instance.dart';

import '../services/auth.dart';
import '../services/database.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late ImplementationSteps implementation;
  late Instance original;
  List<List<List<String>>> newMatrix = [[[]]];
  String path = "";
  bool _isInit = false;
  final AuthService _auth = AuthService();

  void insertArray(int index) {
    newMatrix.insert(index, []);
  }

  void removeArray(int index) {
    if (index >= 0 && index < newMatrix.length) {
      newMatrix.removeAt(index);
    }
  }

  void clearMatrix(int dummy) {
    while (newMatrix.isNotEmpty) {
      removeArray(0);
    }
    newMatrix.add([]);
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      final Map data = ModalRoute.of(context)!.settings.arguments as Map;
      original = data['widget'];
      path = data['path'];
      List<String> deepCopy = List.from(original.descriptions);
      implementation = ImplementationSteps(
        totalSteps: original.descriptions.length,
        descriptions: deepCopy,
        editing: true,
        insertArray: insertArray,
        removeArray: removeArray,
        clearMatrix: clearMatrix,
      );
      _isInit = true;
    }

    return Scaffold(
      backgroundColor: ThemeManager().scaffoldColor,
      appBar: AppBar(
        elevation: 5,
        shadowColor: ThemeManager().buttonAccent,
        backgroundColor: ThemeManager().appBarColor,
        title: Text("Edit Steps", style: TextStyle(color: ThemeManager().primaryColor)),
        centerTitle: true,
      ),
      body: StreamBuilder<TrackerData?>(
        stream: Database(uid: _auth.user!.uid).userData(path),
        builder: (context, snapshot) {

          TrackerData? data = snapshot.data;
          newMatrix = data!.trackerMatrix;
          return ListView(
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
                              children: [
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeManager().buttonPrimary,
                                    ),
                                    onPressed: () async {
                                      List<String> tabNames = await Database(uid: _auth.user!.uid).tabNames;
                                      Navigator.pushReplacementNamed(context, '/home', arguments: {
                                        'tabNames': tabNames,
                                      });
                                    },
                                    child: Text("Cancel"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(10),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ThemeManager().buttonPrimary,
                                    ),
                                    onPressed: () async {
                                      await Database(uid: _auth.user!.uid).updateUserData(
                                          data!.name,
                                          newMatrix,
                                          implementation.descriptions,
                                          data.path,
                                      );
                                      List<String> tabNames = await Database(uid: _auth.user!.uid).tabNames;
                                      Navigator.pushReplacementNamed(context, '/home', arguments: {
                                        'tabNames': tabNames,
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
          );
        }
      ),
    );
  }
}
