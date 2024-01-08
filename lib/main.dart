import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:happywedd1/pages/greetScreen.dart';
import 'package:happywedd1/pages/home.dart';
import 'package:happywedd1/services/auth.dart';
import 'package:happywedd1/pages/splashScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyBskSo1I_C-O3FntgB0dl-WYxD0J7ExwH8',
      appId: '1:280550490177:web:a028bc4128d9e2b87206c0',
      messagingSenderId: '280550490177',
      projectId: 'happywedd1',
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AuthClass authClass = AuthClass();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  Future<void> navigateToNextScreen() async {
    try {
      await Firebase.initializeApp();

      User? user = authClass.auth.currentUser;

      if (user != null) {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(builder: (context) => const GreetScreen()),
        );
      } else {
        navigatorKey.currentState?.pushReplacement(
          MaterialPageRoute(
              builder: (context) =>
                  const SplashScreen(text: 'Welcome to\nHappyWedd')),
        );
      }
    } catch (e) {
      print('Error initializing Firebase: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors.purpleAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
        ),
      ),
      home: SplashScreen(text: 'Welcome to\nHappyWedd'),
      debugShowCheckedModeBanner: false,
    );
  }
}
