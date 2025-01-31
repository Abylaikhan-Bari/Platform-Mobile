import 'package:flutter/material.dart';
import 'components/login_component.dart';
import 'components/register_component.dart';
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Platform Auth'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.login), text: 'Login'),
              Tab(icon: Icon(Icons.person_add), text: 'Register'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            LoginComponent(),
            RegisterComponent(),
          ],
        ),
      ),
    );
  }
}