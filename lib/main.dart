import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/bloc/book_bloc.dart';
import 'package:platform/data/repositories/auth_repository.dart';
import 'package:platform/data/repositories/book_repository.dart';
import 'package:platform/presentation/screens/auth_screen.dart';
import 'package:platform/presentation/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        Provider<AuthRepository>(create: (_) => AuthRepository()),
        Provider<BookRepository>(create: (_) => BookRepository()),
        BlocProvider(
          create: (context) => BookBloc(
            bookUseCases: context.read<BookRepository>(),
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platform',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green, // ✅ Ensures theme consistency
        scaffoldBackgroundColor: Colors.white, // ✅ Matches UI design
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.green, // ✅ Ensure green loading indicator
        ),
      ),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool isProcessingSignOut = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        debugPrint("🔥 AuthState Change Triggered: ${snapshot.data?.email}");

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(), // ✅ Green loading indicator
            ),
          );
        }

        if (isProcessingSignOut) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(), // ✅ Show loading while signing out
            ),
          );
        }

        return snapshot.hasData ? const HomeScreen() : const AuthScreen();
      },
    );
  }
}
