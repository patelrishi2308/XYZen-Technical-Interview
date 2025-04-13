// Flutter imports:
// Package imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master_utility/master_utility.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// Project imports:
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/config/env/env/app_env.dart';
import 'package:tune_stack/config/env/env/my_env.dart';
import 'package:tune_stack/config/sentry/sentry.dart';
import 'package:tune_stack/constants/pref_keys.dart';
import 'package:tune_stack/helpers/device_info_helper.dart';
import 'package:tune_stack/helpers/preference_helper.dart';
import 'package:tune_stack/main.dart';
import 'package:tune_stack/services/firebase_analytics_service.dart';

enum Environment { dev, prod }

class AppConfig {
  Environment? appEnvironment;
  Future<void> setAppConfig({required Environment environment}) async {
    appEnvironment = environment;
    await _initializeApp(environment: environment);
    await PreferenceHelper.setStringPrefValue(
      key: PreferenceKeys.environment,
      value: environment.name,
    );
    await InitSentry().runAppWithSentry(
      const TuneStackApp(),
      environment: environment,
    );
  }

  Future<String> getEnvironment() async {
    final environment = PreferenceHelper.getStringPrefValue(key: PreferenceKeys.environment);
    return environment;
  }

  Future<void> _initializeApp({required Environment environment}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    await SharedPreferenceHelper.init();
    await DeviceInfoHelper.instance.initPlatformState();
    await Supabase.initialize(
      url: MyEnv.supaBaseURL,
      anonKey: MyEnv.supaBaseAnonKey,
    );

    NavigationHelper().setNavigationType(NavigationType.CUPERTINO);
    await AnalyticsService.instance.init();
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: AppColors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.white,
        systemNavigationBarDividerColor: AppColors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    await PreferenceHelper.init(
      encryptionKey: AppEnv.preferenceHelperEncryptionKey,
    );
  }
}
