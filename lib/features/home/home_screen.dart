import 'package:flutter/material.dart';
import 'package:newst/features/home/components/categories.dart';
import 'package:newst/features/home/components/top_news.dart';
import 'package:newst/features/home/components/trending_news.dart';
import 'package:newst/features/home/controllers/home_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController()
        ..fetchEverything()
        ..fetchTopHeadlines(),
      builder: (context, child) {
        // final controller = context.watch<HomeController>();

        return const Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: TrendingNews()),

              SliverToBoxAdapter(child: Categories()),

              TopNews(),
            ],
          ),
        );
      },
    );
  }
}
