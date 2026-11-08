import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  //get instance of firebase auth & google sign in
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  //get current user
  User? getCurrentUser () {
    return _firebaseAuth.currentUser;
  }
  //sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    //try sign in user
    try {
      // sign in user
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
        return userCredential;
    }
    // Catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    //try sign up user
    try {
      // sign up user
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password
        );
        return userCredential;
    }
    // Catch any errors
    on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  //sign in / sign up with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // trigger Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // if user aborted sign-in
      if (googleUser == null) return null;

      // obtain auth details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // create a credential for Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // sign in to Firebase with Google credential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    return await _firebaseAuth.signOut();
  }
}