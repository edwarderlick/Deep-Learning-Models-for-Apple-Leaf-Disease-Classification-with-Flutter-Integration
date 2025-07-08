import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mob/firebase_options.dart';
import 'package:mob/home_page.dart';
import 'auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase initialized successfully');
    await FirebaseAuth.instance.signOut(); // Forces AuthPage on startup
    print('User signed out on startup');
  } catch (e) {
    print('Firebase initialization error: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apple Leaf Disease Detection',
      theme: ThemeData(
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.greenAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 0,
          centerTitle: true,
        ),
      ),
      home: const AuthStateHandler(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AuthStateHandler extends StatelessWidget {
  const AuthStateHandler({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print(
            'StreamBuilder state: ${snapshot.connectionState}, Has data: ${snapshot.hasData}, User: ${snapshot.data?.email}');

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          print(
              'User signed in: ${snapshot.data!.email}, navigating to HomePage');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        print('No user signed in, showing AuthPage');
        return const AuthPage();
      },
    );
  }
}
