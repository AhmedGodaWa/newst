import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/core/widgets/custom_button.dart';
import 'package:newst/core/widgets/custom_text_form_field.dart';
import 'package:newst/features/auth/data/auth_error.dart';
import 'package:newst/features/auth/data/auth_service.dart';
import 'package:newst/features/auth/sign_in/sign_in_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/background/newst_background.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 160.h),

                    Center(
                      child: SvgPicture.asset(
                        'assets/images/logos/newst_logo.svg',
                      ),
                    ),

                    SizedBox(height: 20.h),
                    Text(
                      'Welcome to Newst',
                      style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    CustomTextFormField(
                      controller: _emailController,
                      title: 'Email',
                      hintText: 'Enter your email',
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Email is required';
                        }

                        final emailRegex = RegExp(r'^[\w.-]+@[\w.-]+\.\w+$');

                        if (!emailRegex.hasMatch(value)) {
                          return 'Enter a valid email';
                        }
                        return null;
                      },
                    ),

                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      controller: _passwordController,
                      title: 'Password',
                      hintText: '*************',
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.visiblePassword,
                      maxLines: 1,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password is required';
                        }

                        // if (value.length < 8) {
                        //   return 'Password must be at least 8 characters';
                        // }

                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Password must contain an uppercase letter';
                        }

                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Password must contain a number';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 10.h),

                    CustomTextFormField(
                      controller: _confirmPasswordController,
                      title: 'Confirm Passward',
                      hintText: '*************',
                      textInputAction: TextInputAction.done,
                      textInputType: TextInputType.visiblePassword,
                      maxLines: 1,
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }

                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }

                        return null;
                      },
                    ),

                    SizedBox(height: 15.h),

                    CustomButton(
                      text: 'Sign Up',
                      onPressed: _handleSignUp,
                      isLoading: _isLoading,
                    ),

                    SizedBox(height: 30.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Have an account ?',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(width: 2),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignInScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.bodyLarge!
                                .copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
      );
    } on AuthError catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}
