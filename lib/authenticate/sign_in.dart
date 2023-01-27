import 'package:flutter/material.dart';
import 'package:tracker/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text('Sign In'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        child: ElevatedButton(
          child: Text('Sign in anon'),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if(result == null) {
              print('error signing in');
            } else {
              print('signed in');
              print(result.uid);
            }
          },
        ),
      ),
    );
  }
}
