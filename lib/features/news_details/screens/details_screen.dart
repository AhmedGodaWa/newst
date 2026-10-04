import 'package:flutter/material.dart';
import 'package:newst/core/helpers/date_time_helper.dart';
import 'package:newst/features/home/components/news_card_skeleton.dart';
import 'package:newst/features/home/models/article_model.dart';

class DetailsScreen extends StatelessWidget {
  final ArticleModel article;

  const DetailsScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Details')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  article.urlToImage!,
                  width: double.infinity,
                  height: 228,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return const NewsCardSkeleton(
                      width: double.infinity,
                      height: 228,
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 228,
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported),
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),

              Text(
                article.title ?? 'No title',
                style: Theme.of(context).textTheme.displayLarge,
              ),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.white,
                          child: Image.asset(
                            'assets/images/logos/cnn.png',
                            height: 24,
                          ),
                        ),

                        const SizedBox(width: 4),

                        Flexible(
                          child: Text(
                            article.author ?? 'CNN News',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(formatDateTime(article.publishedAt)),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Icon(Icons.bookmark_border, size: 25),
                ],
              ),

              const SizedBox(height: 12),

              if (article.description != null &&
                  article.description!.isNotEmpty)
                Text(
                  article.description!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium!.copyWith(fontSize: 16),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
