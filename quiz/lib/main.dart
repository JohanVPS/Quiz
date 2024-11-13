import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quiz/firebase_options.dart';
import 'screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(QuizApp());
}

class QuizApp extends StatefulWidget {
  @override
  _QuizAppState createState() => _QuizAppState();
}

class _QuizAppState extends State<QuizApp> {
  bool _isDarkTheme = false;

  void _toggleTheme() {
    setState(() {
      _isDarkTheme = !_isDarkTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _isDarkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Login(toggleTheme: _toggleTheme),
    );
  }
}
