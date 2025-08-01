import 'dart:convert';

import 'package:flutter/services.dart';

import '../model/allergen_model.dart';
import '../model/diet_model.dart';
import '../model/emotion_model.dart';

class LocalService {
  // Load diet options from local JSON file
  static Future<List<DietOption>> fetchLocalDietOptions() async {
    final String response = await rootBundle.loadString(
      'assets/json/diet_options.json',
    );
    final Map<String, dynamic> data = json.decode(response);

    final List<dynamic> dietList = data['dietData'];
    return dietList.map((json) => DietOption.fromJson(json)).toList();
  }

  // Load allergens from local JSON file
  static Future<List<Allergen>> fetchLocalAllergens() async {
    final String response = await rootBundle.loadString(
      'assets/json/food_allergens.json',
    );
    final Map<String, dynamic> data = json.decode(response);

    final List<dynamic> allergenList = data['allergensData'];
    return allergenList.map((json) => Allergen.fromJson(json)).toList();
  }

  // Load emotions from local JSON file
  static Future<List<Emotion>> fetchLocalEmotions() async {
    final String response = await rootBundle.loadString(
      'assets/json/emotions.json',
    );
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> emotionList = data['emotionsData'];
    return emotionList.map((json) => Emotion.fromJson(json)).toList();
  }
}
