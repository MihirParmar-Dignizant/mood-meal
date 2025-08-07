import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mood_meal/constant/api_constant.dart';
import 'package:mood_meal/services/model/onboarding/emotion_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/onboarding/activity_level.dart';
import '../model/onboarding/allergen_model.dart';
import '../model/onboarding/diet_model.dart';
import '../model/onboarding/person_info.dart';

class ApiService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    if (token == null || token.isEmpty)
      throw Exception("Token not found. Please sign in again.");
    return token;
  }

  static Future<http.Response> _getRequest(String endpoint) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConstant.baseUrl}$endpoint');
    return http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );
  }

  static Future<http.Response> _putRequest(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    final token = await _getToken();
    final url = Uri.parse('${ApiConstant.baseUrl}$endpoint');
    return http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );
  }

  static Future<List<DietOption>> fetchDietOptions() async {
    final response = await _getRequest(ApiConstant.dietType);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data']['dietTypes'];
      if (data is List) return data.map((e) => DietOption.fromJson(e)).toList();
      throw Exception("Diet types not found or invalid.");
    }
    throw Exception("Failed to load Diet Options");
  }

  static Future<void> saveSelectedDiets(List<String> dietIds) async {
    final response = await _putRequest(ApiConstant.dietType, {
      'dietTypes': dietIds,
    });
    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('selectedDietTypes', dietIds);
    } else {
      throw Exception("Failed to save selected diet");
    }
  }

  static Future<List<String>> getSavedDietSelections() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('selectedDietTypes') ?? [];
  }

  static Future<List<Allergen>> fetchAllergens() async {
    final response = await _getRequest(ApiConstant.allergies);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      final allAllergies = data['allergies'] as List;
      final selectedIds = List<String>.from(data['selectedAllergies'] ?? []);

      return allAllergies.map((e) {
        final allergen = Allergen.fromJson(e);
        allergen.isSelected = selectedIds.contains(allergen.id);
        return allergen;
      }).toList();
    }
    throw Exception("Failed to fetch allergy options");
  }

  static Future<void> saveAllergens(List<String> allergenIds) async {
    final response = await _putRequest(ApiConstant.allergies, {
      'allergies': allergenIds,
    });
    if (response.statusCode != 200) throw Exception("Failed to save allergies");
  }

  static Future<List<MoodGoal>> fetchMoodGoals() async {
    final response = await _getRequest(
      ApiConstant.moodGoal,
    ); // or http.get if not refactored

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];

      final moods = data['allMoods'] as List<dynamic>? ?? [];
      final selectedMoodId = data['userMoods']?['_id']?.toString() ?? '';

      // This return is important
      return moods.map((moodJson) {
        return MoodGoal.fromJson(moodJson, selectedMoodId: selectedMoodId);
      }).toList();
    } else {
      final error = jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to fetch mood goals: $error');
    }
  }

  static Future<void> updateMoodGoal(String moodGoalId) async {
    final token = await _getToken();
    final url = Uri.parse(
      '${ApiConstant.baseUrl}${ApiConstant.moodGoal}/$moodGoalId',
    );
    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update mood goal');
    }
  }

  static Future<PersonalInfoResponse> updatePersonalInfo({
    required String gender,
    required String age,
    required String weight,
    required String height,
  }) async {
    final response = await _putRequest(ApiConstant.profileDetails, {
      'gender': gender.toLowerCase(),
      'age': age.trim(),
      'weight': weight.replaceAll(RegExp(r'[^0-9]'), ''),
      'height': height.replaceAll(RegExp(r'[^0-9]'), ''),
    });

    if (response.statusCode == 200) {
      return PersonalInfoResponse.fromJson(jsonDecode(response.body));
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['message'] ?? 'Failed to update info');
    }
  }

  static Future<List<ActivityLevel>> fetchActivityLevels() async {
    final response = await _getRequest(ApiConstant.activityLevel);
    if (response.statusCode == 200) {
      final levels =
          jsonDecode(response.body)['data']['activityLevels'] as List;
      return levels.map((e) => ActivityLevel.fromJson(e)).toList();
    }
    throw Exception('Failed to load activity levels');
  }

  static Future<String> submitActivityLevel(String activityLevelId) async {
    final token = await _getToken();
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
    }
    throw Exception('Failed to submit activity level');
  }
}
