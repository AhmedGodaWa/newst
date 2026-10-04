import 'package:flutter/material.dart';
import 'package:newst/core/enums/request_status.dart';
import 'package:newst/core/helpers/date_time_helper.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/home/components/news_card_skeleton.dart';
import 'package:newst/features/home/components/section_header.dart';
import 'package:newst/features/home/controllers/home_controller.dart';
import 'package:newst/features/news_details/screens/details_screen.dart';
import 'package:provider/provider.dart';

class TrendingNews extends StatelessWidget {
  const TrendingNews({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<HomeController>();

    final articles = controller.everythingArticles
        .where(
          (article) =>
              article.urlToImage != null && article.urlToImage!.isNotEmpty,
        )
        .toList();

    return SizedBox(
      height: 290,
      child: Stack(
        children: [
          // Background
          Image.asset(
            'assets/images/background/home_background.png',
            height: 240,
            width: double.infinity,
            fit: BoxFit.cover,
          ),

          // Content
          Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Column(
              children: [
                // Logo
                Text(
                  'NEWST',
                  style: theme.textTheme.displayLarge?.copyWith(
                    color: AppColors.primary,
                    fontSize: 30,
                  ),
                ),
                const SizedBox(height: 10),

                // Trending News + View all
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SectionHeader(
                    title: 'Trending News',
                    onPressed: () {
                      // View all trending news
                    },
                    titleStyle: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.onPrimary,
                    ),
                    actionStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: AppColors.onPrimary,
                      decoration: TextDecoration.underline,
                      decorationColor: AppColors.onPrimary,
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                switch (controller.everythingStatus) {
                  RequestStatus.loading => SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: 10,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        return const NewsCardSkeleton(width: 235, height: 140);
                      },
                    ),
                  ),

                  RequestStatus.success => SizedBox(
                    height: 140,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: articles.take(10).length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(width: 10),
                      itemBuilder: (context, index) {
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
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              children: [
                                Image.network(
                                  article.urlToImage!,
                                  width: 235,
                                  height: 140,
                                  fit: BoxFit.fill,
                                ),

                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withValues(alpha: 0.7),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                Positioned(
                                  left: 10,
                                  right: 10,
                                  bottom: 8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        article.title ?? 'No title',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: theme.textTheme.labelLarge!
                                            .copyWith(
                                              fontFamily: null,
                                              color: AppColors.onPrimary,
                                            ),
                                      ),

                                      const SizedBox(height: 4),

                                      Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              children: [
                                                CircleAvatar(
                                                  backgroundColor: Colors.white,
                                                  child: Image.asset(
                                                    'assets/images/logos/cnn.png',
                                                    height: 20,
                                                  ),
                                                ),

                                                const SizedBox(width: 6),

                                                Expanded(
                                                  child: Text(
                                                    article.author ??
                                                        'CNN News',
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: theme
                                                        .textTheme
                                                        .bodyMedium!
                                                        .copyWith(
                                                          color: AppColors
                                                              .onPrimary,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          Text(
                                            formatDateTime(article.publishedAt),
                                            style: theme.textTheme.bodyMedium!
                                                .copyWith(
                                                  color: AppColors.onPrimary,
                                                  fontSize: 14,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  RequestStatus.error => SizedBox(
                    height: 140,
                    child: Center(
                      child: Text(
                        controller.everythingErrorMessage ??
                            'Something went wrong',
                      ),
                    ),
                  ),
                },
              ],
            ),
          ),
        ],
      ),
    );
  }
}
