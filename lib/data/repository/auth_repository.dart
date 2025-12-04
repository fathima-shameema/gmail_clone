import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmail_clone/data/models/user_account.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // IMPORTANT ✓ enable multiple accounts
  final GoogleSignIn _google = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  // FORCE GOOGLE TO SHOW ACCOUNT PICKER
  Future<AppUser?> signInWithGoogle() async {
    // Always disconnect current session, so Google shows the account picker
    try {
      await _google.disconnect();
    } catch (_) {}

    // Now sign in normally → Google will show account chooser
    final account = await _google.signIn();

    if (account == null) return null;

    final auth = await account.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
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
    await _google.signOut();
    await _auth.signOut();
  }
}
