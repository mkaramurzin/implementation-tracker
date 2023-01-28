import 'package:flutter/material.dart';
import 'package:tracker/authenticate/register.dart';
import 'package:tracker/authenticate/sign_in.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;
  toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ?
      SignIn(toggle: toggleView)
    :
      Register(toggle: toggleView);
  }
}
