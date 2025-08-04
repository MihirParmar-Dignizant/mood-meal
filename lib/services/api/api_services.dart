import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mood_meal/constant/api_constant.dart';

class ApiService {
  // Builds the full URL for an endpoint.
  Uri _buildUrl(String endpoint) {
    return Uri.parse("${ApiConstant.baseUrl}$endpoint");
  }

  // Signs up the user using provided data.
  // Returns `null` if successful, otherwise returns an error message.
  Future<String?> signUp(Map<String, String> data) async {
    try {
      final uri = _buildUrl(ApiConstant.signUp);

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );

      final Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 201 && responseBody["success"] == true) {
        // TODO: Save tokens or user info if needed
        return null;
      } else {
        return responseBody['message'] ?? "Unknown error occurred";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }
}
