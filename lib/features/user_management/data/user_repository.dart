import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collection = 'users';

  Stream<List<UserEntry>> getUsersStream() {
    return _firestore
        .collection(_collection)
        .orderBy('fullname')
        .snapshots()
        .map(
          (snapshot) =>
              snapshot.docs.map((doc) => UserEntry.fromFirestore(doc)).toList(),
        );
  }

  Future<List<UserEntry>> getUsers() async {
    try {
      final snapshot =
          await _firestore.collection(_collection).orderBy('fullname').get();

      return snapshot.docs.map((doc) => UserEntry.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: $e');
    }
  }

  Future<UserEntry?> getUserById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (doc.exists) {
        return UserEntry.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<void> createUser(UserEntry user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.id)
          .set(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  Future<void> updateUser(UserEntry user) async {
    try {
      await _firestore
          .collection(_collection)
          .doc(user.id)
          .update(user.toFirestore());
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).delete();
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  Future<void> bulkDeleteUsers(List<String> userIds) async {
    try {
      final batch = _firestore.batch();

      for (final userId in userIds) {
        final docRef = _firestore.collection(_collection).doc(userId);
        batch.delete(docRef);
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to bulk delete users: $e');
    }
  }

  Future<void> bulkUpdateUserStatus(List<String> userIds, String status) async {
    try {
      final batch = _firestore.batch();

      for (final userId in userIds) {
        final docRef = _firestore.collection(_collection).doc(userId);
        batch.update(docRef, {'status': status});
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to bulk update user status: $e');
    }
  }

  Future<void> updateLastLogin(String userId) async {
    try {
      await _firestore.collection(_collection).doc(userId).update({
        'lastLogin': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      throw Exception('Failed to update last login: $e');
    }
  }

  Future<List<UserEntry>> getUsersByRole(String role) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('role', isEqualTo: role)
              .orderBy('fullname')
              .get();

      return snapshot.docs.map((doc) => UserEntry.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users by role: $e');
    }
  }

  Future<List<UserEntry>> getUsersByStatus(String status) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('status', isEqualTo: status)
              .orderBy('fullname')
              .get();

      return snapshot.docs.map((doc) => UserEntry.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users by status: $e');
    }
  }

  Future<bool> emailExists(String email) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('email', isEqualTo: email)
              .limit(1)
              .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check email existence: $e');
    }
  }
}
