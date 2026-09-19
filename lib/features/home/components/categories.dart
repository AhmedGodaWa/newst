import 'package:flutter/material.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/home/controllers/home_controller.dart';
import 'package:provider/provider.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  final List<String> categories = const [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = context.watch<HomeController>();

    return SizedBox(
      height: 35,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final category = categories[index];

          final isSelected = category == controller.selectedCategory;

          final categoryName =
              category[0].toUpperCase() + category.substring(1);

          return GestureDetector(
            onTap: () {
              controller.selectCategory(category);
            },
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    categoryName,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 6),
                    Container(height: 2, color: AppColors.primary),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
