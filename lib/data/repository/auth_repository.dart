import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmail_clone/data/models/user_account.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _google = GoogleSignIn();

  Future<AppUser?> signInWithGoogle() async {
    final googleUser = await _google.signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);
    final user = userCred.user;

    if (user == null) return null;

    return AppUser(
      uid: user.uid,
      email: user.email ?? "",
      name: user.displayName ?? "",
      photo: user.photoURL,
    );
  }

  Future<void> signOut() async {
    await _auth.signOut();
    await _google.signOut();
  }
}
