import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// **Sign Up a User**
  Future<User?> signUpWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// **Login a User**
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  /// **Get User's Firebase ID Token**
  Future<String?> getUserIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken(true); // 🔥 Force token refresh
    }
    return null;
  }

  /// **Fetch User Role from Firestore**
  Future<String?> getUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final userDoc = await _firestore.collection('roles').doc(user.uid).get();
        if (userDoc.exists) {
          return userDoc.data()?['role'] as String?;
        }
      } catch (e) {
        throw Exception('Failed to fetch user role: $e');
      }
    }
    return null; // Return null if no user or role found
  }

  /// **New Method: Get Current User's Email**
  String? getCurrentUserEmail() {
    return _auth.currentUser?.email; // Returns null if no user is logged in
  }

  /// **Logout the User**
  Future<void> signOut() async => await _auth.signOut();
}
