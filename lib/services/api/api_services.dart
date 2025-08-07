import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mood_meal/constant/api_constant.dart';
import 'package:mood_meal/services/model/onboarding/emotion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/onboarding/activity_level.dart';
import '../model/onboarding/allergen_model.dart';
import '../model/onboarding/diet_model.dart';
import '../model/onboarding/person_info.dart';

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

    //https://mood-meal-backend.onrender.com/api/v1/onboarding/dietType

    debugPrint('api name :  ${ApiConstant.baseUrl}${ApiConstant.dietType}');
    debugPrint('token :  $token');

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
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Access token not found. Please sign in again.');
      }

      final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.moodGoal}');
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final data = decoded['data'];

        final List<dynamic> allMoods = data['allMoods'] ?? [];
        final String selectedMoodId =
            data['userMoods']?['_id']?.toString() ?? '';

        return allMoods.map((moodJson) {
          return MoodGoal.fromJson(moodJson, selectedMoodId: selectedMoodId);
        }).toList();
      } else {
        final errorMsg =
            jsonDecode(response.body)['message'] ?? 'Unknown error';
        throw Exception('Failed to fetch mood goals: $errorMsg');
      }
    } catch (e) {
      debugPrint('Error fetching mood goals: $e');
      throw Exception('Unable to load mood goals. Please try again.');
    }
  }

  // Personal Info
  static Future<PersonalInfoResponse> updatePersonalInfo({
    required String gender,
    required String age,
    required String weight,
    required String height,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('accessToken');

      if (token == null || token.isEmpty) {
        throw Exception('Token not found');
      }

      final url = Uri.parse(
        '${ApiConstant.baseUrl}${ApiConstant.profileDetails}',
      );

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'gender': gender.toLowerCase(),
          'age': age.trim(),
          'weight': weight.replaceAll(RegExp(r'[^0-9]'), ''),
          'height': height.replaceAll(RegExp(r'[^0-9]'), ''),
        }),
      );

      debugPrint('response code: ${response.statusCode}');
      debugPrint('response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PersonalInfoResponse.fromJson(data);
      } else {
        final data = jsonDecode(response.body);
        throw Exception(data['message'] ?? 'Failed to update info');
      }
    } catch (e) {
      debugPrint("catch error: $e");
      rethrow;
    }
  }

  // Activity Level
  static Future<List<ActivityLevel>> fetchActivityLevels() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final url = Uri.parse('${ApiConstant.baseUrl}${ApiConstant.activityLevel}');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List levels = data['data']['activityLevels'];
      return levels.map((e) => ActivityLevel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load activity levels');
    }
  }

  static Future<String> submitActivityLevel(String activityLevelId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');

    final url = Uri.parse(
      '${ApiConstant.baseUrl}${ApiConstant.addActivityLevel}/$activityLevelId',
    );

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['message'] ?? 'Activity level updated successfully';
    } else {
      throw Exception('Failed to submit activity level');
    }
  }
}
