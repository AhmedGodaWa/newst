import 'package:flutter/material.dart';
import 'package:newst/features/home/controllers/home_controller.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController()..fetchEverything(),
      builder: (context, child) {
        final controller = context.watch<HomeController>();

        return Scaffold(
          appBar: AppBar(title: const Text('News')),
          body: controller.isEverythingLoading
              ? const Center(child: CircularProgressIndicator())
              : controller.everythingErrorMessage != null
              ? Center(child: Text(controller.everythingErrorMessage!))
              : ListView.builder(
                  itemCount: controller.everythingArticles.length,
                  itemBuilder: (context, index) {
                    final article = controller.everythingArticles[index];

                    return ListTile(
                      title: Text(article.title ?? 'No title'),
                      subtitle: Text(article.description ?? 'No description'),
                    );
                  },
                ),
        );
      },
    );
  }
}
