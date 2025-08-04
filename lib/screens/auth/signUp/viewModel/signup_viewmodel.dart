import 'package:flutter/material.dart';
import 'package:mood_meal/services/api/api_services.dart';

class SignUpViewModel {
  final formKey = GlobalKey<FormState>();

  final TextEditingController fNameController = TextEditingController();
  final TextEditingController lNameController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final ApiService _authService = ApiService();

  Future<String?> submitForm() async {
    if (!formKey.currentState!.validate()) {
      return "Please fill all fields correctly.";
    }

    formKey.currentState!.save();

    final formData = {
      "firstName": fNameController.text.trim(),
      "lastName": lNameController.text.trim(),
      "userName": userNameController.text.trim(),
      "userEmail": emailController.text.trim(),
      "password": passwordController.text.trim(),
    };

    return await _authService.signUp(formData);
  }
}
