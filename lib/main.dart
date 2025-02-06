import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:platform/bloc/book_bloc.dart';
import 'package:platform/data/repositories/auth_repository.dart';
import 'package:platform/data/repositories/book_repository.dart';
import 'package:platform/presentation/screens/auth_screen.dart';
import 'package:platform/presentation/screens/home_screen.dart';
import 'package:platform/presentation/widgets/exit_confirmation_dialog.dart'; // ✅ Import new dialog
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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: Colors.green,
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

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (context) => const ExitConfirmationDialog(), // ✅ Use the new dialog
    ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // ✅ Handles system back button
      child: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          debugPrint("🔥 AuthState Change Triggered: ${snapshot.data?.email}");

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (isProcessingSignOut) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return snapshot.hasData ? const HomeScreen() : const AuthScreen();
        },
      ),
    );
  }
}
