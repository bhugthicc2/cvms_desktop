import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/violation_model.dart';

class ViolationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'violations';

  Future<void> createViolationReport({
    required String plateNumber,
    required String owner,
    required String violation,
    required String reportedBy,
    String status = 'pending',
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      final violationData = <String, Object>{
        'dateTime': FieldValue.serverTimestamp(),
        'reportedBy': reportedBy,
        'plateNumber': plateNumber,
        'owner': owner,
        'violation': violation,
        'status': status,
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
      };

      if (additionalData != null) {
        additionalData.forEach((key, value) {
          violationData[key] = value;
        });
      }

      await _firestore.collection(_collection).add(violationData);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ViolationEntry>> fetchViolations() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ViolationEntry.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ViolationEntry>> fetchViolationsByPlateNumber(
    String plateNumber,
  ) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('plateNumber', isEqualTo: plateNumber)
              .orderBy('createdAt', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ViolationEntry.fromMap(data, doc.id);
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateViolationStatus(String violationId, String status) async {
    try {
      await _firestore.collection(_collection).doc(violationId).update({
        'status': status,
        'lastUpdated': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<ViolationEntry>> watchViolations() {
    return _firestore
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return ViolationEntry.fromMap(data, doc.id);
          }).toList();
        });
  }

  Future<void> deleteViolation(String violationId) async {
    try {
      await _firestore.collection(_collection).doc(violationId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<String>> getViolationTypes() async {
    try {
      return [
        'Parking Violation',
        'Speed Violation',
        'No Valid Registration',
        'No Valid License',
        'Reckless Driving',
        'Unauthorized Entry',
        'Improper Parking',
        'Vehicle Modification',
        'Other',
      ];
    } catch (e) {
      rethrow;
    }
  }
}
