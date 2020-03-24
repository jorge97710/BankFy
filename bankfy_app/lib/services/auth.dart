import 'package:bankfyapp/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bankfyapp/services/database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid, correo: user.email) : null;
  }

  // Auth change user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged
      .map(_userFromFirebaseUser);
  }

  // Sign in anon
  Future signInAnon() async {
    try {
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }
  
  // Register with email & password
  Future registerWithEmailAndPassword(String email, String password, String nombre, String apellido) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;

      // Crear un nuevo documento para el usuario en Firebase
      await DatabaseService(uid: user.uid).updateUserData(nombre, apellido);
      return _userFromFirebaseUser(user);
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
        print(e.toString());
        return null;
    }
  }
}