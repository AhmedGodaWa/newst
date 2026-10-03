import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/profile/controller/profile_controller.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  Future<void> _showImageSourceDialog(BuildContext context) async {
    final source = await showDialog<ImageSource>(
      context: context,
      barrierColor: Colors.black54,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 40),
          child: Container(
            width: 250,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Select Image Source'),

                ListTile(
                  leading: const Icon(Icons.camera_alt_outlined),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.camera);
                  },
                ),

                ListTile(
                  leading: const Icon(Icons.photo_library_outlined),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (source == null) return;

    if (!context.mounted) return;

    context.read<ProfileController>().pickProfileImage(source);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer<ProfileController>(
        builder: (context, controller, child) {
          return Column(
            children: [
              GestureDetector(
                onTap: () => _showImageSourceDialog(context),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.searchResult,
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: controller.profileImage == null
                            ? Image.asset(
                                'assets/images/logos/profile_logo.jpeg',
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                controller.profileImage!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.searchResult,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 20,
                          color: AppColors.searchResult,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              Text(
                controller.userName ?? 'User',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: AppColors.profileTextPrimary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
