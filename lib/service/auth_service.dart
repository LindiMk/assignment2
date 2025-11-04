import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential.user;
    } catch (e) {
      print("Error signing in: $e");
      return null;
    }
  }

  // Method to get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Method to check if user is signed in
  Future<bool> isUserSignedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString('userId');

    return userId != null;
  }

  // Method to persist user authentication state
  Future<void> persistUser({required User user}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.uid);
  }

  // Method to sign out
  Future<void> signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // clear user id from shared preferences
    await _auth.signOut();
  }
}
