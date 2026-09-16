import 'package:firebase_auth/firebase_auth.dart';
import 'package:allumni_connect/core/utils/custom_exceptions.dart';

class AuthService {
  AuthService({FirebaseAuth? firebaseAuth})
      : _auth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;

  User? get currentUser => _auth.currentUser;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  Future<User> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      if (user == null) throw UnknownAuthException();
      return user;
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw UnknownAuthException();
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw UnknownAuthException();
    }
  }

  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) throw UnknownAuthException();
    try {
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw _mapAuthException(e);
    } catch (_) {
      throw UnknownAuthException();
    }
  }

  Future<void> signOut() => _auth.signOut();

  AuthException _mapAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return InvalidCredentialsException();
      case 'invalid-email':
        return InvalidEmailException();
      case 'user-disabled':
        return UserDisabledException();
      case 'too-many-requests':
        return TooManyRequestsException();
      case 'user-token-expired':
        return SessionExpiredException();
      case 'operation-not-allowed':
        return OperationNotAllowedException();
      case 'network-request-failed':
        return NetworkException();
      default:
        return UnknownAuthException();
    }
  }
}
