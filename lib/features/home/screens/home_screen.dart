import 'package:flutter/material.dart';
import 'package:newst/features/home/components/categories.dart';
import 'package:newst/features/home/components/section_header.dart';
import 'package:newst/features/home/components/top_news.dart';
import 'package:newst/features/home/components/trending_news.dart';
import 'package:newst/features/home/screens/categories_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: TrendingNews()),

          SliverToBoxAdapter(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(
                    title: 'Categories',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoriesScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                const Categories(),
              ],
            ),
          ),

          const TopNews(limit: 20),
        ],
      ),
    );
  }
}
