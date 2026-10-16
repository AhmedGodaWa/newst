import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/news_details/screens/details_screen.dart';
import 'package:newst/features/search/cubit/news_search_cubit.dart';
import 'package:newst/features/search/cubit/news_search_state.dart';

import '../home/models/article_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchTextController = TextEditingController();

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  void _performSearch() {
    final query = searchTextController.text.trim();

    if (query.isEmpty) {
      return;
    }

    context.read<NewsSearchCubit>().searchNews(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextSelectionTheme(
              data: const TextSelectionThemeData(
                cursorColor: AppColors.profileTextPrimary,
                selectionHandleColor: AppColors.profileTextPrimary,
              ),
              child: TextField(
                controller: searchTextController,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _performSearch(),
                cursorColor: AppColors.profileTextPrimary,
                decoration: InputDecoration(
                  hintText: 'Search',
                  suffixIcon: IconButton(
                    onPressed: _performSearch,
                    icon: const Icon(
                      Icons.search,
                      size: 25,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: BlocBuilder<NewsSearchCubit, NewsSearchState>(
                builder: (context, state) {
                  return switch (state) {
                    SearchInitial() => const SizedBox.shrink(),

                    SearchLoading() => const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.searchResult,
                      ),
                    ),

                    SearchSuccess(:final articles) =>
                      articles.isEmpty
                          ? Center(
                              child: Text(
                                'No results found',
                                style: Theme.of(context).textTheme.titleMedium!
                                    .copyWith(
                                      color: AppColors.searchResult,
                                      fontSize: 25,
                                    ),
                              ),
                            )
                          : _buildSearchResults(articles),

                    SearchError(:final message) => Center(child: Text(message)),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<ArticleModel> articles) {
    return ListView.separated(
      itemCount: articles.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final article = articles[index];

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetailsScreen(article: article),
              ),
            );
          },
          contentPadding: EdgeInsets.zero,
          leading: const Icon(
            Icons.search,
            color: AppColors.searchResult,
            size: 20,
          ),
          title: Text(
            article.title ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.titleMedium!.copyWith(color: AppColors.searchResult),
          ),
        );
      },
    );
  }
}
