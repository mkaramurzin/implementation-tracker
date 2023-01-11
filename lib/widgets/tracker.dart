import 'package:flutter/material.dart';

class Tracker {
  String name;
  double currentStep;
  Widget deleteButton = const SizedBox(height: 28, width: 56);
  double offset;

  Tracker({required this.name, this.currentStep = 0, this.offset = 0});
}