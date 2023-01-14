import 'package:flutter/material.dart';

class Tracker {
  String name;
  double currentStep;
  double offset;
  Widget widget;

  Tracker({required this.name, this.currentStep = 0, this.offset = 0, required this.widget});
}