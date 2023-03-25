import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/pages/loading.dart';
import 'package:tracker/services/database.dart';
import 'package:tracker/widgets/trackers/active.dart';
import '../services/auth.dart';

class TrackerForm extends StatefulWidget {
  final String path;

  TrackerForm({required this.path});

  @override
  _TrackerFormState createState() => _TrackerFormState();
}

class _TrackerFormState extends State<TrackerForm> {
  final _textController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Active newTracker = Active(name: '', deleteButton: Container());
  String _selectedColor = '#000000';
  String _selectedBackgroundColor = '#000000';
  final AuthService _auth = AuthService();

  void updateTracker() {
    newTracker = Active(
        name: _textController.text,
        deleteButton: Container(),
        color: _selectedColor,
        backgroundColor: _selectedBackgroundColor);
  }

  void _showColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(int.parse(
                  _selectedColor.replaceAll('#', '0xFF'))),
              onColorChanged: (Color color) {
                setState(() {
                  _selectedColor =
                  '#${color.value.toRadixString(16)
                      .substring(2)
                      .toUpperCase()}';
                  updateTracker();
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showBackgroundColorPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a background color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(int.parse(_selectedBackgroundColor
                  .replaceAll('#', '0xFF'))),
              onColorChanged: (Color color) {
                setState(() {
                  _selectedBackgroundColor =
                  '#${color.value.toRadixString(16)
                      .substring(2)
                      .toUpperCase()}';
                  updateTracker();
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.35,
      child: StreamBuilder<TrackerData?>(
          stream: Database(uid: _auth.user!.uid).userData(widget.path),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              TrackerData? data = snapshot.data;
              List<List<List<String>>> trackerMatrix =
                  data!.trackerMatrix;
              return Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.25,
                      child: TextFormField(
                        onChanged: (text) {
                          setState(() {
                            updateTracker();
                          });
                        },
                        controller: _textController,
                        autofocus: true,
                        decoration:
                        InputDecoration(labelText: 'Tracker Name'),
                        validator: (text) {
                          if (_textController.text.isEmpty) {
                            return "Please name the tracker";
                          } else if (trackerMatrix.any((sublist) =>
                          sublist
                              .where((name) =>
                          name[0] == _textController.text)
                              .isNotEmpty)) {
                            return "Tracker with that name already exists";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Text('Select Colors'),
                    SizedBox(height: 7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _showColorPickerDialog();
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(
                                      int.parse(
                                          _selectedColor.replaceAll('#', '0xFF'))),
                                ),
                              ),
                            ),
                            Text('Inner')
                          ],
                        ),
                        SizedBox(width: 10),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _showBackgroundColorPickerDialog();
                              },
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Color(int.parse(_selectedBackgroundColor
                                      .replaceAll('#', '0xFF'))),
                                ),
                              ),
                            ),
                            Text('Outer')
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    newTracker,
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text("Add"),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          List<String> newTracker = [
                            _textController.text,
                            _selectedColor,
                            _selectedBackgroundColor
                          ];
                          trackerMatrix[0].add(newTracker);
                          await Database(uid: _auth.user!.uid).updateUserData(
                              data.name,
                              trackerMatrix,
                              data.descriptions,
                              data.path);
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ),
              );
            } else {
              print('error with snapshot in tracker form');
              return Loading();
            }
          }),
    );
  }
}
