import 'package:flutter/material.dart';
import 'package:tracker/widgets/instance.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  void setup() async {
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      'widget': Instance(trackerMatrix: [], descriptions: ['test', 'tnt', '', 'lol','lolo'])
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            setup();
          }, child: Text("click"),
        )
      ),
    );
  }
}
