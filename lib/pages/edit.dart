import 'package:flutter/material.dart';
import 'package:tracker/widgets/implementation_steps.dart';

class Edit extends StatefulWidget {
  const Edit({Key? key}) : super(key: key);

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  late ImplementationSteps implementation;
  bool _isInit = false;

  @override
  Widget build(BuildContext context) {
    if (!_isInit) {
      final Map data = ModalRoute.of(context)!.settings.arguments as Map;
      final ImplementationSteps impl = data['widget'];
      implementation = ImplementationSteps(
        totalSteps: impl.totalSteps,
        descriptions: impl.descriptions,
        editing: true,
      );
      _isInit = true;
    }

    return Scaffold(
      body: Container(
        margin: EdgeInsets.fromLTRB(200, 40, 0, 0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              implementation
            ]
        ),
      ),
    );
  }
}
