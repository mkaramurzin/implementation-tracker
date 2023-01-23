import 'package:flutter/material.dart';
import 'package:tracker/widgets/instance.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late List<Instance> tabs;
  Map data = {};

  @override
  Widget build(BuildContext context) {
    print('build');
    data = data.isNotEmpty ? data : ModalRoute.of(context)!.settings.arguments as Map;

    Instance instance = data['widget'];
    print(instance.descriptions.length);
    return Scaffold(

      body: instance,
    );
  }
}

