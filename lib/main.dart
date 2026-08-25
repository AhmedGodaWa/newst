import 'package:flutter/material.dart';
import 'package:newst/core/theme/app_theme.dart';
import 'package:newst/features/splash/splash_screen.dart';

void main() {
  runApp(const NewstApp());
}

class NewstApp extends StatelessWidget {
  const NewstApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,

      home: const SplashScreen(),
    );
  }
}
