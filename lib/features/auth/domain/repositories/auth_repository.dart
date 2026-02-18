import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInWithGoogle();
  Future<void> signOut();
}
