import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class SanctionResponse {
  final bool success;
  final String sanctionType;
  final int offenseNumber;
  final String? sanctionId;
  final String? vehicleStatus;
  final String? endAt;
  final String timestamp;

  SanctionResponse({
    required this.success,
    required this.sanctionType,
    required this.offenseNumber,
    this.sanctionId,
    this.vehicleStatus,
    this.endAt,
    required this.timestamp,
  });

  factory SanctionResponse.fromJson(Map<String, dynamic> json) {
    return SanctionResponse(
      success: json['success'] ?? false,
      sanctionType: json['sanctionType'] ?? '',
      offenseNumber: json['offenseNumber'] ?? 0,
      sanctionId: json['sanctionId'],
      vehicleStatus: json['vehicleStatus'],
      endAt: json['endAt'],
      timestamp: json['timestamp'] ?? '',
    );
  }
}

Future<SanctionResponse> triggerSanction({
  required String violationId,
  required String vehicleId,
  required String adminUserId,
  String baseUrl = 'http://localhost:3000', // Override with production URL
}) async {
  final uri = Uri.parse("$baseUrl/api/sanctions/from-violation");

  debugPrint('🚀 Triggering sanction request...');
  debugPrint('📍 URL: $uri');
  debugPrint(
    '📋 Data: violationId=$violationId, vehicleId=$vehicleId, adminUserId=$adminUserId',
  );

  try {
    final response = await http
        .post(
          uri,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'violationId': violationId,
            'vehicleId': vehicleId,
            'confirmedBy': adminUserId,
          }),
        )
        .timeout(
          const Duration(seconds: 30),
          onTimeout: () => throw Exception('Request timeout after 30 seconds'),
        );

    debugPrint('📊 Response Status: ${response.statusCode}');
    debugPrint('📄 Response Body: ${response.body}');

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body) as Map<String, dynamic>;
      return SanctionResponse.fromJson(responseData);
    } else {
      final errorData =
          response.body.isNotEmpty ? jsonDecode(response.body) : null;
      final errorMessage =
          errorData?['message'] ?? errorData?['error'] ?? 'Unknown error';

      throw Exception(
        "Sanction request failed: ${response.statusCode} - $errorMessage",
      );
    }
  } catch (e) {
    debugPrint('❌ Sanction request error: $e');
    rethrow;
  }
}
