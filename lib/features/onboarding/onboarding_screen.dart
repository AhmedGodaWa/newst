import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newst/core/theme/app_colors.dart';
import 'package:newst/features/home/home_screen.dart';
import 'package:newst/features/onboarding/controller/onboarding_controller.dart';
import 'package:newst/features/onboarding/models/onboarding_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingController(),
      child: Builder(
        builder: (context) => Scaffold(
          backgroundColor: const Color(0xFFF5F5F5),
          body: SafeArea(
            child: Column(
              children: [
                // Skip area
                SizedBox(
                  height: 48.h,
                  child: Selector<OnboardingController, int>(
                    selector: (context, controller) => controller.currentIndex,
                    builder: (context, currentIndex, child) {
                      return currentIndex !=
                              OnboardingModel.onboardingData.length - 1
                          ? Padding(
                              padding: const EdgeInsets.only(
                                top: 10,
                                bottom: 5,
                                right: 5,
                              ),
                              child: Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    // Skip logic will be added later.
                                  },
                                  child: const Text('Skip'),
                                ),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),

                // Onboarding content + indicator
                Expanded(
                  child: Column(
                    children: [
                      // Pages
                      Expanded(
                        child: PageView.builder(
                          controller: pageController,
                          itemCount: OnboardingModel.onboardingData.length,
                          onPageChanged: (index) {
                            context.read<OnboardingController>().changePage(
                              index,
                            );
                          },
                          itemBuilder: (context, index) {
                            final onboarding =
                                OnboardingModel.onboardingData[index];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Image.asset(onboarding.image, width: 287.w),

                                  SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height *
                                        0.03,
                                  ),

                                  Text(
                                    onboarding.title,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge!
                                        .copyWith(
                                          color: AppColors.onboardingTitle,
                                        ),
                                  ),

                                  SizedBox(
                                    height:
                                        MediaQuery.sizeOf(context).height *
                                        0.015,
                                  ),

                                  Text(
                                    onboarding.description,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(
                                          color:
                                              AppColors.onboardingDescription,
                                        ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // 20 between description and indicator
                      const SizedBox(height: 20),

                      // Indicator
                      SmoothPageIndicator(
                        controller: pageController,
                        count: OnboardingModel.onboardingData.length,
                        effect: SwapEffect(
                          activeDotColor: AppColors.primary,
                          dotColor: AppColors.borderLight,
                          dotHeight: 10.h,
                          dotWidth: 10.w,
                          spacing: 6.w,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: MediaQuery.sizeOf(context).height * 0.10),

                // Bottom button
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Selector<OnboardingController, bool>(
                    selector: (context, controller) => controller.isLastPage,
                    builder: (context, isLastPage, child) {
                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            if (isLastPage) {
                              // Get Started logic
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            }

                            pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          },
                          child: Text(isLastPage ? 'Get Started' : 'Next'),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
