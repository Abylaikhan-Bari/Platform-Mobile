import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<String?> getUserIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken(true); // 🔥 Force token refresh
    }
    return null;
  }

  Future<void> signOut() async => await _auth.signOut();

  /// **New Method: Fetch User Role**
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
}
