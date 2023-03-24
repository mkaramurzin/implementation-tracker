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

  late List<String> tabs = [];
  late Instance instance;
  Map data = {};
  late String instancePath;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;

    tabs = data['tabNames'];

    return StreamProvider<List<TrackerData?>?>.value(
      value: Database(uid: _auth.user!.uid).data,
      initialData: [],
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: TabBarView(
            children: tabs.map((name) => Instance(name: name)).toList(),
          ),
          bottomNavigationBar: Material(
            color: Colors.blueGrey[900],
            child: TabBar(
              isScrollable: true,
              tabs: tabs.map((title) {
                return Tab(text: title);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}

