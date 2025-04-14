// Flutter imports:
import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
import 'package:toastification/toastification.dart';
import 'package:tune_stack/features/splash/views/splash_screen.dart';

// Project imports:]

class TuneStackApp extends StatelessWidget {
  const TuneStackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: ProviderScope(
        child: MasterUtilityMaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(
              alwaysUse24HourFormat: true,
            ),
            child: DismissKeyboard(
              child: child ?? const SplashScreen(),
            ),
          ),
          scrollBehavior: const ScrollBehavior().copyWith(overscroll: false),
          home: const SplashScreen(),
          
        ),
      ),
    );
  }
}
