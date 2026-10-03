import 'package:flutter/material.dart';
import 'package:newst/features/profile/controller/profile_controller.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_form_field.dart';

class PersonalInfoBottomSheet extends StatefulWidget {
  const PersonalInfoBottomSheet({super.key, required this.controller});

  final ProfileController controller;

  @override
  State<PersonalInfoBottomSheet> createState() =>
      _PersonalInfoBottomSheetState();
}

class _PersonalInfoBottomSheetState extends State<PersonalInfoBottomSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _nameController = TextEditingController(
      text: widget.controller.userName ?? '',
    );

    _emailController = TextEditingController(
      text: widget.controller.userEmail ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Listener(
      onPointerMove: (event) {
        if (keyboardHeight > 0 && event.delta.dy > 0) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: keyboardHeight),
        child: Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textSecondary,
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  'Profile Info',
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(height: 24),

                CustomTextFormField(
                  controller: _nameController,
                  title: 'Name',
                  hintText: 'Enter your name',
                  textInputAction: TextInputAction.next,
                ),

                const SizedBox(height: 20),

                CustomTextFormField(
                  controller: _emailController,
                  title: 'Email',
                  hintText: 'Email',
                  readOnly: true,
                ),

                const SizedBox(height: 32),

                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: 'Save',
                    isLoading: _isLoading,
                    onPressed: () async {
                      final name = _nameController.text.trim();

                      if (name.isEmpty) {
                        return;
                      }

                      setState(() {
                        _isLoading = true;
                      });

                      try {
                        await widget.controller.updateUserName(name);

                        if (!context.mounted) return;

                        Navigator.pop(context);
                      } catch (e) {
                        if (!mounted) return;

                        setState(() {
                          _isLoading = false;
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to update name'),
                          ),
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
