import 'package:flutter/material.dart';
import 'package:tracker/services/auth.dart';
import 'package:tracker/services/extension.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[900],
        title: Text(
          'Reset Password',
          style: TextStyle(color: "#FFA611".toColor()),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              margin: EdgeInsets.only(top: 150),
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey, width: 1),
                  borderRadius: BorderRadius.circular(10)
              ),
              width: 500,
              height: 310,
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            ),
          ),
        ),
      ),
    );
  }
}
