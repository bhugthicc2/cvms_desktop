import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

Future<void> triggerSanction({
  required String violationId,
  required String vehicleId,
  required String adminUserId,
}) async {
  final response = await http.post(
    Uri.parse("http://localhost:3000/sanctions/from-violation"),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'violationId': violationId,
      'vehicleId': vehicleId,
      'confirmedBy': adminUserId,
    }),
  );

  debugPrint('STATUS: ${response.statusCode}');
  debugPrint('BODY: ${response.body}');

  if (response.statusCode != 200) {
    throw Exception(
      "Failed to create sanction: ${response.statusCode} ${response.body}",
    );
  }
}
