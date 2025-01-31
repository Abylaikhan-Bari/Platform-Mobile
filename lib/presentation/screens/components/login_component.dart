import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/repositories/auth_repository.dart';

class LoginComponent extends StatefulWidget {
  const LoginComponent({super.key});

  @override
  _LoginComponentState createState() => _LoginComponentState();
}

class _LoginComponentState extends State<LoginComponent> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration("Email"),
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _passwordController,
              decoration: _inputDecoration("Password"),
              obscureText: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator(color: Colors.green)
                : ElevatedButton(
              style: _buttonStyle(),
              onPressed: _handleLogin,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await context.read<AuthRepository>().login(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login successful!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Login failed: ${e.toString()}')),
          );
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your email';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return 'Invalid email format';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Please enter your password';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
