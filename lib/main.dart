import 'package:flutter/material.dart';
import 'package:tracker/pages/home.dart';
import 'package:tracker/pages/edit.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => Home(),
      '/edit': (context) => Edit(),
    },
  ));
}