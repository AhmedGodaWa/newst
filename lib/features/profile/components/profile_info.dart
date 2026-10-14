import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/auth/data/auth_service.dart';
import 'package:newst/features/auth/sign_in/sign_in_screen.dart';
import 'package:newst/features/bookmark/controllers/bookmark_controller.dart';
import 'package:newst/features/profile/components/personal_info_bottom_sheet.dart';
import 'package:newst/features/profile/components/profile_option.dart';
import 'package:newst/features/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfileInfo extends StatelessWidget {
  const ProfileInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Profile Info',
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(color: AppColors.profileTextPrimary),
        ),

        const SizedBox(height: 8),

        ProfileOption(
          icon: Icons.person_outline,
          title: 'Personal Info',
          onTap: () {
            final controller = context.read<ProfileController>();

            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              enableDrag: true,
              backgroundColor: Colors.transparent,
              builder: (_) {
                return PersonalInfoBottomSheet(controller: controller);
              },
            );
          },
        ),

        ProfileOption(
          icon: Icons.language,
          title: 'Language',
          onTap: () {
            // Change language
          },
        ),

        Consumer<ProfileController>(
          builder: (context, controller, child) => ProfileOption(
            icon: Icons.flag_outlined,
            title: controller.country ?? 'Country',
            onTap: () {
              // Select country

              final controller = context.read<ProfileController>();

              showCountryPicker(
                context: context,
                countryListTheme: CountryListThemeData(
                  backgroundColor: AppColors.background,
                  bottomSheetHeight: MediaQuery.sizeOf(context).height * 0.8,
                  textStyle: Theme.of(context).textTheme.titleMedium,
                  searchTextStyle: Theme.of(context).textTheme.titleMedium,
                  inputDecoration: InputDecoration(
                    labelText: 'Search',
                    labelStyle: Theme.of(context).textTheme.bodyMedium!
                        .copyWith(color: AppColors.searchHint),
                    hintText: 'Search',
                    hintStyle: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: AppColors.searchHint,
                    ),
                    suffixIcon: const Icon(Icons.search),
                  ),
                ),
                header: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Select your country',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                onSelect: (Country country) async {
                  await controller.selectCountry(country);
                },
              );
            },
          ),
        ),

        ProfileOption(
          icon: Icons.description_outlined,
          title: 'Terms & Conditions',
          onTap: () {
            // Open Terms & Conditions
          },
        ),

        Consumer<ProfileController>(
          builder: (context, controller, child) {
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.logout_outlined,
                color: AppColors.primary,
              ),
              title: Text(
                'Logout',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium!.copyWith(color: AppColors.primary),
              ),
              trailing: controller.isLoggingOut
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : const Icon(Icons.chevron_right, color: AppColors.primary),
              onTap: controller.isLoggingOut
                  ? null
                  : () async {
                      try {
                        await controller.logout();
                        if (!context.mounted) return;

                        // Keep persisted bookmarks for the account, but do
                        // not expose them while another account is signed out
                        // or being selected.
                        context.read<BookmarkController>().clearInMemory();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignInScreen(),
                          ),
                          (route) => false,
                        );
                      } catch (e) {
                        if (!context.mounted) return;

                        // Supabase sign-out may have succeeded before local
                        // profile cleanup failed. Do not retain the previous
                        // user's bookmarks in memory in that case.
                        if (AuthService().currentSession == null) {
                          context.read<BookmarkController>().clearInMemory();
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to logout')),
                        );
                      }
                    },
            );
          },
        ),
      ],
    );
  }
}
