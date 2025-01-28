import 'dart:convert';
import 'package:http/http.dart' as http; // Add this import

import '../../core/constants/app_constants.dart';
import '../../core/network/api_service.dart';
import '../../core/network/firebase_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();
  final FirebaseService _firebaseService = FirebaseService();

  Future<void> login(String email, String password) async {
    try {
      // 1. Firebase authentication
      await _firebaseService.loginWithEmail(email, password);

      // 2. Backend authentication
      final response = await _apiService.login(email, password);
      if (response.statusCode != 200) {
        throw Exception('Failed to authenticate with backend');
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> register(String email, String password) async {
    // 1. Firebase registration
    await _firebaseService.signUpWithEmail(email, password);

    // 2. Backend registration
    final response = await _apiService.register(email, password);
    if (response.statusCode != 200) {
      throw Exception('Failed to register with backend');
    }
  }

  Future<void> assignRole(String role) async {
    final token = await _firebaseService.getUserIdToken();
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.rolesEndpoint}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'role': role}),
    );
    if (response.statusCode != 200) {
      throw Exception('Role assignment failed: ${response.body}');
    }
  }
}