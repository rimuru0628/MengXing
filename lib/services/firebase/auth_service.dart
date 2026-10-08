import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  String? get currentUserId => _auth.currentUser?.uid;

  // Email / password registration
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.sendEmailVerification();
    return credential;
  }

  // Email / password login
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) =>
      _auth.signInWithEmailAndPassword(email: email, password: password);

  // Google Sign-In
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // Web uses popup flow
        final provider = GoogleAuthProvider();
        provider.addScope('email');
        provider.addScope('profile');
        return await _auth.signInWithPopup(provider);
      }
      // Mobile uses native Google Sign-In SDK
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      return _auth.signInWithCredential(credential);
    } catch (e) {
      throw Exception('Google sign-in failed: $e');
    }
  }

  // Apple Sign-In (iOS only)
  Future<UserCredential> signInWithApple() async {
    final provider = OAuthProvider('apple.com')
      ..addScope('email')
      ..addScope('name');
    return _auth.signInWithProvider(provider);
  }

  // Forgot password
  Future<void> sendPasswordResetEmail(String email) =>
      _auth.sendPasswordResetEmail(email: email);

  // Email verification
  Future<void> sendEmailVerification() =>
      _auth.currentUser!.sendEmailVerification();

  Future<bool> get isEmailVerified async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  // Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Account deletion
  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
  }

  // Re-authenticate before sensitive operations
  Future<void> reauthenticateWithEmail({
    required String email,
    required String password,
  }) async {
    final credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );
    await _auth.currentUser?.reauthenticateWithCredential(credential);
  }
}
