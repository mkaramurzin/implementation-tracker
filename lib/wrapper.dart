import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracker/authenticate/authenticate.dart';
import 'package:tracker/pages/home.dart';
import 'package:tracker/pages/loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User?>(context);

    // return either home or authenticate
    if(user == null) {
      return Authenticate();
    } else {
      return Loading();
    }
  }
}
