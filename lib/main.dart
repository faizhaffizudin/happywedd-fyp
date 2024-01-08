import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
  Widget currentPage = const SplashScreen(
    text: 'Welcome to\nHappyWedd',
  );
  AuthClass authClass = AuthClass();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    String? token = await authClass.getToken();
    if (token != null) {
      setState(() {
        currentPage = const HomePage();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
        hintColor: Colors.purpleAccent,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple,
          ),
        ),
        // inputDecorationTheme: InputDecorationTheme(
        //   // Customize the dropdown theme here
        //   filled: true,
        //   fillColor: Colors.white,
        // ),
        // Other theme configurations...
      ),
      home: SplashScreen(
        text: 'Welcome to\nHappyWedd',
      ),
      debugShowCheckedModeBanner: false, // Make sure this is set to false
    );
  }
}
