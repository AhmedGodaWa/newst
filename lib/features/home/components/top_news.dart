import 'package:flutter/material.dart';
import 'package:newst/core/enums/request_status.dart';
import 'package:newst/core/helpers/date_time_helper.dart';
import 'package:newst/features/home/components/news_card_skeleton.dart';
import 'package:newst/features/home/controllers/home_controller.dart';
import 'package:newst/features/news_details/screens/details_screen.dart';
import 'package:provider/provider.dart';

class TopNews extends StatelessWidget {
  const TopNews({super.key, this.limit});

  final int? limit;

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    final filteredArticles = controller.topHeadlinesArticles
        .where(
          (article) =>
              article.urlToImage != null && article.urlToImage!.isNotEmpty,
        )
        .toList();

    final articles = limit == null
        ? filteredArticles
        : filteredArticles.take(limit!).toList();

    switch (controller.topHeadlinesStatus) {
      case RequestStatus.loading:
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            return const NewsCardSkeleton(width: 120, height: 70);
          }, childCount: 20),
        );

      case RequestStatus.success:
        return SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final article = articles[index];

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailsScreen(article: article),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 5,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        article.urlToImage!,
                        width: 120,
                        height: 70,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 120,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 8),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            article.title ?? 'No title',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),

                          Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.white,
                                child: Image.asset(
                                  'assets/images/logos/cnn.png',
                                  height: 16,
                                ),
                              ),

                              const SizedBox(width: 4),              

                              Expanded(
                                child: Text(
                                  article.author ?? 'CNN News',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),

                              const SizedBox(width: 8),

                              Text(
                                formatDateTime(article.publishedAt),
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),

                              const Spacer(),

                              const Icon(Icons.bookmark_border, size: 25),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }, childCount: articles.length),
        );

      case RequestStatus.error:
        return SliverToBoxAdapter(
          child: Center(
            child: Text(
              controller.topHeadlinesErrorMessage ?? 'Something went wrong',
            ),
          ),
        );
    }
  }
}
