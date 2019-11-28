import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class AuthService {

  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  FirebaseUser currentUser;

  getCurrentUser() {
    return currentUser;
  }

  Future<bool> signIn() async {
    bool loginSuccess;
    try {
      GoogleSignInAccount googleUser = await googleSignIn.signIn(); // [1]
      GoogleSignInAuthentication googleAuth = await googleUser.authentication; // [2]

      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      currentUser = await auth.signInWithCredential(credential);
      loginSuccess = true;
      
    } catch (error) {
      print(error);
      loginSuccess = false;
    }
    return loginSuccess;
  }

  Future<void> signOut() async {
    googleSignIn.disconnect();
  }
}
