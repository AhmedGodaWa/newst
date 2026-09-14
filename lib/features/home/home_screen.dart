import 'package:flutter/material.dart';
import 'package:newst/features/home/components/trending_news.dart';
import 'package:newst/features/home/controllers/home_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController()..fetchEverything(),
      builder: (context, child) {
       // final controller = context.watch<HomeController>();

        return const Scaffold(
          body: TrendingNews()
        );
      },
    );
  }
}
