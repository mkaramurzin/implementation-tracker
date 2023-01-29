import 'package:firebase_auth/firebase_auth.dart';
import 'package:tracker/services/database.dart';
import 'package:tracker/widgets/instance.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user object based on FirebaseUser
  User? get user => _auth.currentUser;

  // auth change user stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // sign in anonymously
  Future signInAnon() async {
    print('here');
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
}

  // sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      // create a new document for the user with the uid
      // starter data
      Instance instance = Instance(trackerMatrix: [], descriptions: ['node1', 'node2', 'node3', 'node4']);
      List<Instance> instList = [instance];
      print(await Database(uid: user!.uid).updateUserData(0));

      return user;
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
}