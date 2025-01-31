import 'package:flutter/material.dart';
import 'components/login_component.dart';
import 'components/register_component.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;

  void toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   "assets/logo.png", // Replace with actual logo asset
                        //   height: 120,
                        // ),
                        const SizedBox(height: 30),
                        isLogin ? const LoginComponent() : const RegisterComponent(),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: toggleAuthMode,
                          child: Text(
                            isLogin
                                ? "Don't have an account? Register"
                                : "Already have an account? Login",
                            style: const TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
