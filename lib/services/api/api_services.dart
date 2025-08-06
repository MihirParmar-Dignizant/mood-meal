import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mood_meal/constant/api_constant.dart';
import 'package:mood_meal/services/model/onboarding/emotion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/onboarding/allergen_model.dart';
import '../model/onboarding/diet_model.dart';

class ApiService {
  // Diet type
  static Future<List<DietOption>> fetchDietOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Token not found. Please sign in again.");
    }

    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.dietType}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        final data = json['data'];
        final dietTypes = data != null ? data['dietTypes'] : null;

        if (dietTypes == null || dietTypes is! List) {
          throw Exception("Diet types not found or invalid.");
        }

        return dietTypes.map((e) => DietOption.fromJson(e)).toList();
      } else {
        debugPrint("Failed to fetch diet options: ${response.body}");
        throw Exception("Failed to load Diet Options");
      }
    } catch (e) {
      debugPrint("Error in fetchDietOptions: $e");
      throw Exception("Failed to load Diet Options");
    }
  }

  static Future<void> saveSelectedDiets(List<String> dietIds) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception("Token not found. Please sign in again.");
    }

    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.dietType}');

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'dietTypes': dietIds}),
      );

      if (response.statusCode == 200) {
        // Save locally after success
        await prefs.setStringList('selectedDietTypes', dietIds);
        debugPrint("Selected diets saved successfully.");
      } else {
        debugPrint("Failed to save selected diet: ${response.body}");
        throw Exception("Failed to save selected diet");
      }
    } catch (e) {
      debugPrint("Error in saveSelectedDiets: $e");
      throw Exception("Failed to save selected diet");
    }
  }

  static Future<List<String>> getSavedDietSelections() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('selectedDietTypes') ?? [];
  }

  // Allergies
  static Future<List<Allergen>> fetchAllergens() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found. Please sign in again.');
    }

    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.allergies}');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];
        final allAllergies = data['allergies'] as List;
        final selectedIds = List<String>.from(data['selectedAllergies'] ?? []);

        return allAllergies.map((e) {
          final allergen = Allergen.fromJson(e);
          allergen.isSelected = selectedIds.contains(allergen.id);
          return allergen;
        }).toList();
      } else {
        throw Exception("Failed to fetch allergy options");
      }
    } catch (e) {
      debugPrint("Error in fetchAllergens: $e");
      throw Exception("Error loading allergies");
    }
  }

  static Future<void> saveAllergens(List<String> allergenIds) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception('Token is not found, please Sign In Again.');
    }

    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.allergies}');

    final body = jsonEncode({'allergies': allergenIds});

    try {
      final response = await http.put(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );
      if (response.statusCode != 200) {
        debugPrint("Save allergen failed: ${response.body}");
        throw Exception("Failed to save allergies");
      }
    } catch (e) {
      debugPrint("Error in saveAllergens: $e");
      throw Exception("Failed to save Allergy Preferences");
    }
  }

  static Future<List<MoodGoal>> fetchMoodGoals() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    if (token == null || token.isEmpty) {
      throw Exception('Token not found. Please sign in again.');
    }

    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.moodGoal}');

    try {
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];
        final allMoods = data['allMoods'] as List;
        final selectedMoodId = data['userMoods']?['_id'];

        return allMoods
            .map(
              (moodJson) =>
                  MoodGoal.fromJson(moodJson, selectedMoodId: selectedMoodId),
            )
            .toList();
      } else {
        throw Exception('Failed to fetch mood goals');
      }
    } catch (e) {
      debugPrint('Error fetching mood goals: $e');
      throw Exception('Failed to load mood goals');
    }
  }
}
