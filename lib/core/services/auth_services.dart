import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../models/user_model.dart';

class AuthService {
  // Create a new account using email and password
  Future<UserModel?> createAccountWithEmail(
      String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return UserModel.fromFirebaseUser(
          userCredential.user!); // Return UserModel
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // Login with email and password
  Future<UserModel?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return UserModel.fromFirebaseUser(
          userCredential.user!); // Return UserModel
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }

  // Logout the user
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    // Logout from Google if logged in with Google
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
  }

  // Check whether the user is signed in or not
  Future<bool> isLoggedIn() async {
    var user = FirebaseAuth.instance.currentUser;
    return user != null;
  }

  // Login with Google
  Future<UserModel?> continueWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null; // User canceled the sign-in

      // Send auth request
      final GoogleSignInAuthentication gAuth = await googleUser.authentication;

      // Obtain a new credential
      final creds = GoogleAuthProvider.credential(
          accessToken: gAuth.accessToken, idToken: gAuth.idToken);

      // Sign in with the credentials
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(creds);

      return UserModel.fromFirebaseUser(
          userCredential.user!); // Return UserModel
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return null;
    }
  }
}
