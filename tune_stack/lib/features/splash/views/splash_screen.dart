// Flutter imports:
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_strings.dart';
import 'package:tune_stack/features/auth/views/auth_screen.dart';
import 'package:tune_stack/features/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:tune_stack/features/splash/presentation/splash_future_provider.dart';
import 'package:tune_stack/helpers/preference_helper.dart';
// Project imports:

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.6, curve: Curves.easeIn),
      ),
    );

    init();
    _controller
      ..forward()
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if ((SharedPreferenceHelper.getString(AppStrings.userID) != null) &&
              (true == SharedPreferenceHelper.getString(AppStrings.userID)?.isNotEmpty)) {
            NavigationHelper.navigatePushRemoveUntil(
              route: const BottomNavBarScreen(),
            );
          } else {
            NavigationHelper.navigatePushRemoveUntil(
              route: const AuthScreen(),
            );
          }
        }
      });
  }

  Future<void> init() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final ref = ProviderScope.containerOf(context);
      final splashStateNotifier = ref.read(splashStateNotifierProvider.notifier);
      await splashStateNotifier.init(context);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: const Text(
                  'TUNESTACK',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 2,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(1, 2),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
