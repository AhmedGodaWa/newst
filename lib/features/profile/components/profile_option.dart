import 'package:flutter/material.dart';
import 'package:newst/core/theme/app_colors.dart';

class ProfileOption extends StatelessWidget {
  const ProfileOption({
    super.key,
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Icon(
            icon,
            color: AppColors.profileTextPrimary,
          ),
          title: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: AppColors.profileTextPrimary,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.profileTextPrimary,
          ),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}