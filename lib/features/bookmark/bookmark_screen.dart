import 'package:flutter/material.dart';
import 'package:newst/core/helpers/date_time_helper.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/bookmark/controllers/bookmark_controller.dart';
import 'package:newst/features/home/components/news_card_skeleton.dart';
import 'package:newst/features/home/models/article_model.dart';
import 'package:newst/features/news_details/screens/details_screen.dart';
import 'package:provider/provider.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookmarks')),
      body: Consumer<BookmarkController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: 8,
              itemBuilder: (context, index) {
                return const NewsCardSkeleton(width: 120, height: 70);
              },
            );
          }

          if (controller.errorMessage != null && !controller.hasBookmarks) {
            return _BookmarkMessage(
              icon: Icons.error_outline,
              message: controller.errorMessage!,
              actionLabel: 'Try again',
              onActionPressed: controller.loadBookmarks,
            );
          }

          if (!controller.hasBookmarks) {
            return const _BookmarkMessage(
              icon: Icons.bookmark_border,
              message: 'No saved articles yet',
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.loadBookmarks,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: controller.bookmarks.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final article = controller.bookmarks[index];
                return _BookmarkArticleTile(article: article);
              },
            ),
          );
        },
      ),
    );
  }
}

class _BookmarkArticleTile extends StatelessWidget {
  const _BookmarkArticleTile({required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    final imageUrl = article.urlToImage;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => DetailsScreen(article: article)),
        );
      },
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: imageUrl == null || imageUrl.isEmpty
            ? Container(
                width: 120,
                height: 70,
                color: Colors.grey.shade200,
                child: const Icon(Icons.image_not_supported),
              )
            : Image.network(
                imageUrl,
                width: 120,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 70,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
      ),
      title: Text(
        article.title ?? 'No title',
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Row(
          children: [
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
          ],
        ),
      ),
      trailing: IconButton(
        tooltip: 'Remove bookmark',
        onPressed: () async {
          final bookmarkController = context.read<BookmarkController>();
          await bookmarkController.removeBookmark(article);

          if (!context.mounted) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                bookmarkController.errorMessage ?? 'Removed from bookmarks',
              ),
            ),
          );
        },
        icon: const Icon(
          Icons.bookmark_remove,
          color: AppColors.primary,
          size: 25,
        ),
      ),
    );
  }
}

class _BookmarkMessage extends StatelessWidget {
  const _BookmarkMessage({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (actionLabel != null && onActionPressed != null) ...[
              const SizedBox(height: 12),
              TextButton(onPressed: onActionPressed, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
