import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newst/features/main/main_screen.dart';
import 'package:newst/features/onboarding/onboarding_screen.dart';
import 'package:newst/features/splash/controllers/splash_controller.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final controller = context.read<SplashController>();

    final hasSeenOnboarding = await controller.hasSeenOnboarding();

    if (!mounted) return;

    if (!hasSeenOnboarding) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingScreen()),
      );

      return;
    }

    // final isLoggedIn = await controller.isLoggedIn();

    // if (!mounted) return;

    // if (!isLoggedIn) {
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (_) => const SignInScreen()),
    //   );

    //   return;
    // }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/background/newst_background.png',
              fit: BoxFit.cover,
            ),
          ),
          Center(child: SvgPicture.asset('assets/images/logos/newst_logo.svg')),
        ],
      ),
    );
  }
}
