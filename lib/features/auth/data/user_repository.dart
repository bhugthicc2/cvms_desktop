import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/error/firebase_error_handler.dart';
import '../../../core/services/activity_log_service.dart';

/// Repository for handling user data operations in Firestore
/// Follows single responsibility principle - only user data operations
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';
  final ActivityLogService _logger = ActivityLogService();

  Future<String?> getUserFullname(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data()?['fullname'] as String?;
  }

  /// Get complete user data from Firestore
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return doc.data();
  }

  /// Create user profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    required String fullname,
    required String email,
    required String password,
    String role = 'cdrrmsu admin', //todo change into cdrrmsu admin soon
    String status = 'inactive',
  }) async {
    try {
      await _firestore.collection(_collection).doc(uid).set({
        'fullname': fullname,
        'email': email,
        'password':
            password, // Note: Consider removing password storage for security
        'role': role,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });

      // Log user profile creation
      await _logger.logUserCreated(uid, email);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Update user login status and timestamp
  Future<void> updateLoginStatus(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
        'status': 'active',
      });

      // Log login status update (user session activation)
      await _logger.logUserLoginUpdated(uid, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Update user status to inactive
  Future<void> updateUserStatus(String uid, String status) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'status': status,
        'lastUpdated': FieldValue.serverTimestamp(),
      });

      // Log user status change
      await _logger.logUserStatusUpdated(uid, status, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Stream user profile changes
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserProfile(String uid) {
    return _firestore.collection(_collection).doc(uid).snapshots();
  }

  /// Update user profile fields
  Future<void> updateUserProfile(
    String uid,
    Map<String, dynamic> updates,
  ) async {
    try {
      updates['lastUpdated'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(uid).update(updates);

      // Log user profile update
      await _logger.logUserUpdated(uid, null);
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      // Get user data before deletion for logging
      final userDoc = await _firestore.collection(_collection).doc(uid).get();
      final userEmail = userDoc.data()?['email'] as String?;

      await _firestore.collection(_collection).doc(uid).delete();

      // Log user profile deletion
      if (userEmail != null) {
        await _logger.logUserDeleted(uid, userEmail, null);
      }
    } catch (e) {
      throw Exception(FirebaseErrorHandler.handleFirestoreError(e));
    }
  }
}
