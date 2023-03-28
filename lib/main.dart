import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:tracker/pages/edit.dart';
import 'package:tracker/pages/home.dart';
import 'package:tracker/pages/loading.dart';
import 'package:tracker/pages/message.dart';
import 'package:tracker/services/auth.dart';
import 'package:tracker/services/themes.dart';
import 'package:tracker/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyBAkhOpwwOd6-bdqdIJ_Z69CdxFJj0hIKY",
      appId: "1:727206002439:web:067d620dfdfd9aa81dcfa2",
      messagingSenderId: "727206002439",
      projectId: "implementation-tracker"
    )
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User?>.value(
      value: AuthService().authStateChanges,
      initialData: null,
      child: MaterialApp(
        home: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              print(snapshot.error);
            } else {
              print('connected');
              return MaterialApp(
                initialRoute: '/',
                routes: {
                  '/': (context) => Wrapper(),
                  '/home': (context) => Home(),
                  '/edit': (context) => Edit(),
                  '/message': (context) => Message(),
                  '/loading': (context) => Loading(),
                },
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}