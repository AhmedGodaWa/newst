import 'package:flutter/material.dart';
import 'package:newst/core/enums/request_status.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/search/controllers/news_search_controller.dart';
import 'package:provider/provider.dart';

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

    context.read<NewsSearchController>().searchNews(query);
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
              child: Consumer<NewsSearchController>(
                builder: (context, controller, child) {
                  if (!controller.hasSearched) {
                    return const SizedBox.shrink();
                  }

                  switch (controller.searchStatus) {
                    case RequestStatus.loading:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.searchResult,
                        ),
                      );

                    case RequestStatus.success:
                      if (controller.searchResults.isEmpty) {
                        return Center(
                          child: Text(
                            'No results found',
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(
                                  color: AppColors.searchResult,
                                  fontSize: 25,
                                ),
                          ),
                        );
                      }

                      return _buildSearchResults(controller);

                    case RequestStatus.error:
                      return Center(
                        child: Text(
                          controller.searchErrorMessage ??
                              'Something went wrong',
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(NewsSearchController controller) {
    return ListView.separated(
      itemCount: controller.searchResults.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final article = controller.searchResults[index];

        return ListTile(
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
