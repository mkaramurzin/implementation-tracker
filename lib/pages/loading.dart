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
  late BuildContext _context;

  void setup() async {
    List<String> names = await Database(uid: _auth.user!.uid).names;
    Navigator.pushReplacementNamed(_context, '/home', arguments: {
      'names': names
    });
  }

  @override
  void initState() {
    super.initState();
    _context = context;
    setup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[900],
      body: const Center(
        child: SpinKitSpinningLines(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
