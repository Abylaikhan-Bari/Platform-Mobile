import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platform/presentation/screens/books_screen.dart';
import 'package:platform/presentation/screens/auth_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggingOut = false;
  String? userEmail;

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  void _fetchUserEmail() {
    final user = FirebaseAuth.instance.currentUser;
    setState(() {
      userEmail = user?.email ?? "Unknown User"; // ✅ Handles null email properly
    });
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          elevation: 6,
          backgroundColor: Colors.white, // White background for consistency
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sign Out",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.black),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Are you sure you want to sign out?",
                  style: TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
                    ),
                    TextButton(
                      onPressed: () async {
                        setState(() {
                          isLoggingOut = true;
                        });

                        await FirebaseAuth.instance.signOut();
                        if (mounted) {
                          Navigator.of(context).pop(); // ✅ Close dialog
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                            );
                          });
                        }
                      },
                      child: const Text("Sign Out", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Full white background
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),

            // ✅ Displays current user's email
            Center(
              child: Column(
                children: [
                  const Text(
                    "Welcome to Platform",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    userEmail ?? "Loading...", // ✅ Displays user email
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            _buildMenuButton(Icons.book, "Books", () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const BooksScreen()));
            }),
            _buildMenuButton(Icons.logout, "Sign Out", _confirmLogout),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.grey[200], // Light gray for contrast
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black54, size: 28), // Dark gray for visibility
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontSize: 18, color: Colors.black),
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.black45, size: 18),
          ],
        ),
      ),
    );
  }
}
