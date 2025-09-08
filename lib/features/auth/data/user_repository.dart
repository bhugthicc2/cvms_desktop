import 'package:cloud_firestore/cloud_firestore.dart';

/// Repository for handling user data operations in Firestore
/// Follows single responsibility principle - only user data operations
class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  /// Create user profile in Firestore
  Future<void> createUserProfile({
    required String uid,
    required String fullname,
    required String email,
    required String password,
    String role = 'admin',
    String status = 'inactive',
  }) async {
    try {
      await _firestore.collection(_collection).doc(uid).set({
        'fullname': fullname,
        'email': email,
        'password': password, // Note: Consider removing password storage for security
        'role': role,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Update user login status and timestamp
  Future<void> updateLoginStatus(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
        'status': 'active',
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Update user status to inactive
  Future<void> updateUserStatus(String uid, String status) async {
    try {
      await _firestore.collection(_collection).doc(uid).update({
        'status': status,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  /// Get user profile data
  Future<Map<String, dynamic>?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore.collection(_collection).doc(uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      rethrow;
    }
  }

  /// Stream user profile changes
  Stream<DocumentSnapshot<Map<String, dynamic>>> watchUserProfile(String uid) {
    return _firestore.collection(_collection).doc(uid).snapshots();
  }

  /// Update user profile fields
  Future<void> updateUserProfile(String uid, Map<String, dynamic> updates) async {
    try {
      updates['lastUpdated'] = FieldValue.serverTimestamp();
      await _firestore.collection(_collection).doc(uid).update(updates);
    } catch (e) {
      rethrow;
    }
  }

  /// Delete user profile
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore.collection(_collection).doc(uid).delete();
    } catch (e) {
      rethrow;
    }
  }
}
