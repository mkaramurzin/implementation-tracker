import 'package:flutter/material.dart';
import 'package:tracker/pages/home.dart';
import 'package:tracker/pages/edit.dart';
import 'package:tracker/pages/loading.dart';
import 'package:tracker/widgets/instance.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Loading(),
      '/home': (context) => Home(),
      '/edit': (context) => Edit(),
    },
  ));
}