import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SecurityService {
  SecurityService({FirebaseFirestore? db}) : _db = db ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  // Check if user is verified (CIN + additional checks)
  Future<bool> isUserVerified(String userId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) return false;

    final data = userDoc.data()!;
    final cinVerified = (data['cinNumber'] ?? '').toString().isNotEmpty &&
                       (data['cinFileUrl'] ?? '').toString().isNotEmpty;
    
    // Additional security checks can be added here
    final phoneVerified = (data['phone'] ?? '').toString().isNotEmpty;
    final emailVerified = FirebaseAuth.instance.currentUser?.emailVerified ?? false;

    return cinVerified && phoneVerified && emailVerified;
  }

  // Log security events
  Future<void> logSecurityEvent({
    required String userId,
    required String eventType,
    String? details,
  }) async {
    await _db.collection('security_logs').add({
      'userId': userId,
      'eventType': eventType,
      'details': details,
      'timestamp': FieldValue.serverTimestamp(),
      'ipAddress': 'unknown', // Could be enhanced with actual IP
      'userAgent': 'CarShare App',
    });
  }

  // Check for suspicious activity
  Future<bool> hasSuspiciousActivity(String userId) async {
    final logs = await _db
        .collection('security_logs')
        .where('userId', isEqualTo: userId)
        .where('timestamp', isGreaterThan: DateTime.now().subtract(const Duration(hours: 24)))
        .get();
    
    // Check for multiple failed login attempts
    final failedLogins = logs.docs.where((doc) => 
        doc.data()['eventType'] == 'login_failed').length;
    
    return failedLogins > 5;
  }

  // Rate limiting for sensitive operations
  Future<bool> canPerformOperation(String userId, String operation) async {
    final lastOperation = await _db
        .collection('rate_limits')
        .where('userId', isEqualTo: userId)
        .where('operation', isEqualTo: operation)
        .where('timestamp', isGreaterThan: DateTime.now().subtract(const Duration(minutes: 5)))
        .get();
    
    return lastOperation.docs.isEmpty;
  }

  // Record operation for rate limiting
  Future<void> recordOperation(String userId, String operation) async {
    await _db.collection('rate_limits').add({
      'userId': userId,
      'operation': operation,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Validate phone number format (Tunisia)
  bool isValidTunisianPhone(String phone) {
    // Remove spaces, dashes, etc.
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\(\)]'), '');
    
    // Check for Tunisian phone formats: +216 XX XXX XXX or 0X XXX XXX
    final tunisianRegex = RegExp(r'^(\+216|0)?[2-9]\d{7}$');
    return tunisianRegex.hasMatch(cleanPhone);
  }

  // Sanitize user input
  static String sanitizeInput(String input) {
    if (input.isEmpty) return input;
    return input.replaceAll(RegExp(r'[<>"\'&]'), '');
  }

  // Check if user account is locked
  Future<bool> isAccountLocked(String userId) async {
    final userDoc = await _db.collection('users').doc(userId).get();
    if (!userDoc.exists) return false;

    final data = userDoc.data()!;
    final lockedUntil = data['lockedUntil'] as Timestamp?;
    if (lockedUntil == null) return false;

    return lockedUntil.toDate().isAfter(DateTime.now());
  }

  // Lock user account temporarily
  Future<void> lockAccount(String userId, Duration duration) async {
    await _db.collection('users').doc(userId).update({
      'lockedUntil': Timestamp.fromDate(DateTime.now().add(duration)),
    });

    await logSecurityEvent(
      userId: userId,
      eventType: 'account_locked',
      details: 'Duration: ${duration.inMinutes} minutes',
    );
  }

  // Unlock user account
  Future<void> unlockAccount(String userId) async {
    await _db.collection('users').doc(userId).update({
      'lockedUntil': FieldValue.delete(),
    });

    await logSecurityEvent(
      userId: userId,
      eventType: 'account_unlocked',
      details: 'Manual unlock',
    );
  }
}
