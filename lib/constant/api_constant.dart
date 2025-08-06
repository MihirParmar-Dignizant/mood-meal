class ApiConstant {
  static final ApiConstant _singleton = ApiConstant._internal();

  factory ApiConstant() {
    return _singleton;
  }

  ApiConstant._internal();

  // Base URl
  static const String baseUrl = "https://mood-meal-backend.onrender.com/api/v1";

  // Authentication
  static const signUp = "/auth/signup";
  static const signIn = "/auth/signin";
  static const googleAuth = "/auth/google";
  static const logout = "/auth/logout";
  static const forgot = "/auth/forgot-password";
  static const verify = "/auth/verify";
  static const resetPassword = "/auth/reset-password";
  static const refreshToken = "/auth/refresh-token";

  // Onboarding screen
  static const String activityLevel = "/onboarding/activity-level";
  static const String allergies = "/onboarding/allergies";
  static const String moodGoal = "/onboarding/mood-goal";
  static const String profileDetails = "/onboarding/profile-details";
  static const String dietType = "/onboarding/dietType";
}
