import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

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
