import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:platform/core/constants/app_constants.dart';
import 'package:platform/core/network/firebase_service.dart';

class ApiService {
  final FirebaseService _firebaseService = FirebaseService();

  Future<http.Response> _authenticatedRequest(
      String method,
      String endpoint, {
        Map<String, dynamic>? body,
      }) async {
    final token = await _firebaseService.getUserIdToken();
    if (token == null) {
      throw Exception("User is not authenticated.");
    }

    final url = Uri.parse('${AppConstants.baseUrl}$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token', // ✅ Correct token usage
    };

    switch (method.toUpperCase()) {
      case 'GET':
        return await http.get(url, headers: headers);
      case 'POST':
        return await http.post(url, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return await http.put(url, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return await http.delete(url, headers: headers);
      default:
        throw Exception('Invalid HTTP method');
    }
  }
//Authentication methods
  Future<http.Response> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.authEndpoint}/login'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<http.Response> register(String email, String password) async {
    final response = await http.post(
      Uri.parse('${AppConstants.baseUrl}${AppConstants.authEndpoint}/register'),
      body: jsonEncode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );
    return response;
  }

  Future<List<dynamic>> getBooks() async {
    final response = await _authenticatedRequest('GET', AppConstants.booksEndpoint);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to fetch books: ${response.body}");
    }
  }

  Future<dynamic> createBook(Map<String, dynamic> bookData) async {
    final response = await _authenticatedRequest(
      'POST',
      AppConstants.booksEndpoint,
      body: bookData,
    );
    return jsonDecode(response.body);
  }

  Future<dynamic> updateBook(String id, Map<String, dynamic> bookData) async {
    final response = await _authenticatedRequest(
      'PUT',
      '${AppConstants.booksEndpoint}/$id',
      body: bookData,
    );
    return jsonDecode(response.body);
  }

  Future<void> deleteBook(String id) async {
    await _authenticatedRequest(
      'DELETE',
      '${AppConstants.booksEndpoint}/$id',
    );
  }
}