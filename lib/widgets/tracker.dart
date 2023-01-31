import 'package:flutter/material.dart';

class Tracker {
  String name;
  Widget widget;
  bool fill;

  Tracker({required this.name, required this.widget, this.fill = false});
}