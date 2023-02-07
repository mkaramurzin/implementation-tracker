import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tracker/models/tracker_data.dart';
import 'package:tracker/services/auth.dart';
import 'package:tracker/services/extension.dart';
import 'package:tracker/widgets/instance.dart';
import 'package:tracker/widgets/tracker.dart';
import 'package:tracker/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tracker/widgets/trackers/active.dart';
import 'package:tracker/widgets/tracker_form.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<Instance> tabs = [];
  late Instance instance;
  Map data = {};
  final AuthService _auth = AuthService();

  void menuOption(int option) async {
    switch(option) {
      case 0:
        showModalBottomSheet(context: context, isScrollControlled: true, builder: (context) {
          return TrackerForm();
        });
        break;

      case 1:
        Navigator.pushReplacementNamed(context, '/edit', arguments: {
          'widget': instance
        });
        break;

      case 2:
        await _auth.signOut();
        Navigator.pushReplacementNamed(context, '/message');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;

    instance = data['widget'];
    // tabs.add(instance);


    return StreamProvider<TrackerData?>.value(
      value: Database(uid: _auth.user!.uid).userData,
      initialData: null,
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[900],
            title: Text("Implementation Tracker", style: TextStyle(color: "#FFA611".toColor())),
            centerTitle: true,
            actions: [
              PopupMenuButton<int>(
                icon: Icon(Icons.settings, color: "#FFA611".toColor()),
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
            color: Colors.blueGrey[900],
            child: TabBar(
              isScrollable: true,
              tabs: tabs.map((title) {
                return Tab(text: 'tab');
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

