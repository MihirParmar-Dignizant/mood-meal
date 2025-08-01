import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/allergen_model.dart';
import '../model/diet_model.dart';
import '../model/emotion_model.dart';

class ApiService {
  // Diet Options API
  static Future<List<DietOption>> fetchDietOptions() async {
    final response = await http.get(
      Uri.parse('https://your-api.com/diet-options'),
    );

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => DietOption.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Diet Options');
    }
  }

  // Allergen Options API
  static Future<List<Allergen>> fetchAllergens() async {
    final response = await http.get(
      Uri.parse('https://your-api.com/allergens'),
    );

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(response.body);
      return jsonList.map((json) => Allergen.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Allergen Options');
    }
  }

  // Fetch Emotion List from API (GET)
  static Future<List<Emotion>> fetchEmotions() async {
    final response = await http.get(Uri.parse("https://your-api.com/emotions"));

    if (response.statusCode == 200) {
      List jsonList = jsonDecode(
        response.body,
      ); // direct array, not wrapped in "emotionsData"
      return jsonList.map((json) => Emotion.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load Emotion Options');
    }
  }
}
