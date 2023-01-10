import 'package:flutter/material.dart';

class TrackerValues {
  String name;
  double currentStep;
  Widget deleteButton = const SizedBox(height: 28, width: 56);

  TrackerValues({required this.name, this.currentStep = 1});
}