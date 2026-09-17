import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newst/core/config/supabase_config.dart';
import 'package:newst/core/storage/app_preferences.dart';
import 'package:newst/core/theme/app_theme.dart';
import 'package:newst/features/home/controllers/home_controller.dart';
import 'package:newst/features/onboarding/controller/onboarding_controller.dart';
import 'package:newst/features/splash/controllers/splash_controller.dart';
import 'package:newst/features/splash/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppPreferences.instance.init();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.publishableKey,
  );

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
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => SplashController()),
            ChangeNotifierProvider(create: (_) => OnboardingController()),
            ChangeNotifierProvider(create: (_) => HomeController()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            home: const SplashScreen(),
          ),
        );
      },
    );
  }
}
