class AppConstants {
  // App Information
  static const String appName = 'Smart Trip Planner';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Your AI-powered travel companion';

  // API Configuration
  static const String baseUrl = 'https://api.smarttripplanner.com';
  static const String apiVersion = 'v1';
  static const String apiKey = 'your_api_key_here';

  // OpenAI Configuration
  static const String openAIApiKey = 'your_openai_api_key_here';
  static const String openAIModel = 'gpt-3.5-turbo';
  static const int maxTokens = 1000;

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String tripsKey = 'trips_data';
  static const String settingsKey = 'app_settings';
  static const String onboardingKey = 'onboarding_completed';

  // Animation Durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);

  // Page Sizes
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Validation Constants
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 50;
  static const int minNameLength = 2;
  static const int maxNameLength = 50;
  static const int maxTripNameLength = 100;
  static const int maxDescriptionLength = 500;

  // Trip Constants
  static const int maxTripDuration = 365; // days
  static const int minTripDuration = 1; // days
  static const int maxActivitiesPerDay = 10;
  static const int maxPhotosPerTrip = 50;

  // Chat Constants
  static const int maxChatHistoryLength = 100;
  static const int maxMessageLength = 1000;
  static const Duration typingIndicatorDelay = Duration(milliseconds: 1000);

  // Image Constants
  static const int maxImageSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'webp'];

  // Network Constants
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;

  // Error Messages
  static const String networkErrorMessage = 'Network connection error. Please check your internet connection.';
  static const String serverErrorMessage = 'Server error. Please try again later.';
  static const String unknownErrorMessage = 'An unexpected error occurred. Please try again.';
  static const String timeoutErrorMessage = 'Request timeout. Please try again.';
  static const String authErrorMessage = 'Authentication failed. Please login again.';

  // Success Messages
  static const String loginSuccessMessage = 'Login successful!';
  static const String signupSuccessMessage = 'Account created successfully!';
  static const String profileUpdateSuccessMessage = 'Profile updated successfully!';
  static const String tripCreatedSuccessMessage = 'Trip created successfully!';
  static const String tripUpdatedSuccessMessage = 'Trip updated successfully!';
  static const String tripDeletedSuccessMessage = 'Trip deleted successfully!';

  // Regular Expressions
  static const String emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String phoneRegex = r'^\+?[\d\s\-\(\)]+$';
