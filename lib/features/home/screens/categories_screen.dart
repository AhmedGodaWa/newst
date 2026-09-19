import 'package:flutter/material.dart';
import 'package:newst/features/home/components/categories.dart';
import 'package:newst/features/home/components/top_news.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: const BackButton(),
        title: const Text('Categories'),
      ),
      body: const CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: Categories()),
          TopNews(),
        ],
      ),
    );
  }
}
