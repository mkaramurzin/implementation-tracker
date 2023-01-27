import 'package:flutter/material.dart';

class Message extends StatelessWidget {
  const Message({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/');
          },
          child: Text('Click'),
        ),
      ),
    );
  }
}
