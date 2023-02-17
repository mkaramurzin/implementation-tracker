import 'package:flutter/material.dart';
import 'package:tracker/services/database.dart';
import 'package:tracker/widgets/instance.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/auth.dart';

class Loading extends StatefulWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  final AuthService _auth = AuthService();

  void setup() async {
    Navigator.pushReplacementNamed(context, '/home', arguments: {
      // 'widget': Instance(name: "placeholder", descriptions: ['test', 'tnt', '', 'lol','lolo']), // TODO get rid of this line
      'names': await Database(uid: _auth.user!.uid).names
    });
  }

  @override
  void initState() {
    super.initState();
    // setup();
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
