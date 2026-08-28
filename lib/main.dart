import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newst/core/theme/app_theme.dart';
import 'package:newst/features/onboarding/onboarding_screen.dart';

void main() {
  runApp(const NewstApp());
}

class NewstApp extends StatelessWidget {
  const NewstApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const OnboardingScreen(),
          //SplashScreen(), 
        );
      },
    );
  }
}
