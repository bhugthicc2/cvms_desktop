import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//class for firebase operations
class FirebaseService {
  //firebase auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //firebase firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      //sign in using firebase auth
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      //record lastlogin and update the status in firestore
      if (userCredential.user != null) {
        await _firestore
            .collection('users')
            .doc(userCredential.user!.uid)
            .update({'lastLogin': DateTime.now(), 'status': 'active'});
      }
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> signUp(String email, String password, String fullname) async {
    try {
      //create a user using firebase auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      //record a user in firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'fullname': fullname,
        'email': email,
        'password': password,
        'role': 'admin', // Set default role to admin for desktop users
        'status': 'inactive',
      });
      return userCredential.user;
    } catch (e) {
      rethrow;
    }
  }
}
