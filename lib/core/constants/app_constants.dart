class AppConstants {
  // For local development (Android emulator)
  static const String baseUrl = 'http://192.168.0.31:5001/api';

  // If using physical device/remote server:
  // static const String baseUrl = 'http://<YOUR_IP>:5001';

  // Endpoints
  static const String authEndpoint = '/api/auth';
  static const String booksEndpoint = '/api/books';
  static const String rolesEndpoint = '/api/roles';

  static const Duration apiTimeout = Duration(seconds: 30);
}