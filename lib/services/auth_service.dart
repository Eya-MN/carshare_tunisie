import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'security_service.dart';

class AuthService {
  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  final FirebaseAuth _auth;
  final SecurityService _securityService = SecurityService();

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Check if account is locked
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (userDoc.docs.isNotEmpty) {
        final userId = userDoc.docs.first.id;
        if (await _securityService.isAccountLocked(userId)) {
          throw FirebaseAuthException(
            code: 'account-locked',
            message: 'Ce compte est temporairement verrouillé pour des raisons de sécurité.',
          );
        }
      }

      final result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      
      // Log successful login
      await _securityService.logSecurityEvent(
        userId: result.user!.uid,
        eventType: 'login_success',
        details: 'Email: $email',
      );
      
      return result;
    } on FirebaseAuthException catch (e) {
      // Log failed login attempt
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        // Try to find user ID for logging
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();
        
        if (userDoc.docs.isNotEmpty) {
          final userId = userDoc.docs.first.id;
          await _securityService.logSecurityEvent(
            userId: userId,
            eventType: 'login_failed',
            details: 'Email: $email, Reason: ${e.code}',
          );
          
          // Check for suspicious activity
          if (await _securityService.hasSuspiciousActivity(userId)) {
            await _securityService.lockAccount(userId, const Duration(minutes: 15));
          }
        }
      }
      rethrow;
    }
  }

  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      
      // Log successful registration
      await _securityService.logSecurityEvent(
        userId: result.user!.uid,
        eventType: 'registration_success',
        details: 'Email: $email',
      );
      
      return result;
    } on FirebaseAuthException catch (e) {
      // Log failed registration attempt
      await _securityService.logSecurityEvent(
        userId: 'unknown',
        eventType: 'registration_failed',
        details: 'Email: $email, Reason: ${e.code}',
      );
      rethrow;
    }
  }

  Future<UserCredential> signInOrCreateWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return await _auth.createUserWithEmailAndPassword(email: email, password: password);
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    final user = _auth.currentUser;
    if (user != null) {
      await _securityService.logSecurityEvent(
        userId: user.uid,
        eventType: 'logout',
        details: 'User signed out',
      );
    }
    return _auth.signOut();
  }

  // Additional security methods
  Future<bool> isUserVerified(String userId) async {
    return await _securityService.isUserVerified(userId);
  }

  Future<bool> canPerformOperation(String userId, String operation) async {
    return await _securityService.canPerformOperation(userId, operation);
  }

  Future<void> recordOperation(String userId, String operation) async {
    await _securityService.recordOperation(userId, operation);
  }

  bool isValidTunisianPhone(String phone) {
    return _securityService.isValidTunisianPhone(phone);
  }

  String sanitizeInput(String input) {
    return SecurityService.sanitizeInput(input);
  }
}
