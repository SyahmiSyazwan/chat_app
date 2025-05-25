import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    clientId: '', // Only needed for web
  );
  String? get userEmail => _user?.email;
  String? get userName => _user?.displayName;
  String? get userPhotoUrl => _user?.photoURL;

  User? _user;
  bool _isLoading = false;

  User? get currentUser => _user;
  bool get isLoading => _isLoading;

  Future<void> signInWithGoogle() async {
  try {
    _isLoading = true;
    notifyListeners();

    // Force account selection by signing out first
    await _googleSignIn.signOut();

    // Trigger Google Sign-In flow with prompt for account selection
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return;

    // Rest of your sign-in logic...
    final GoogleSignInAuthentication googleAuth = 
        await googleUser.authentication;

    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final UserCredential userCredential = 
        await _auth.signInWithCredential(credential);
    _user = userCredential.user;
    debugPrint('''
  User logged in:
  - UID: ${userCredential.user?.uid}
  - Name: ${userCredential.user?.displayName}
  - Email: ${userCredential.user?.email}
  - Photo URL: ${userCredential.user?.photoURL}
''');
  } catch (e) {
    debugPrint('Google Sign-In Error: $e');
    rethrow;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      _user = null;
    } finally {
      notifyListeners();
    }
  }
}
