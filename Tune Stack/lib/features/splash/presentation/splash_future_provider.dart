// Flutter imports:
// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:async';

import 'package:flutter/material.dart';
// Package imports:
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
// Project imports:

final splashStateNotifierProvider = StateNotifierProvider<SplashStateNotifier, String>(
  (ref) => SplashStateNotifier(),
);

class SplashStateNotifier extends StateNotifier<String> {
  SplashStateNotifier() : super('');

  Future<void> init(BuildContext context) async {
    SizeHelper.setMediaQuerySize(context: context);
    // try {
    //   dioClient.setConfiguration(AppEnv.baseUrl);
    // } catch (e) {
    //   LogHelper.logError('SplashStateNotifier : $e');
    // }
  }
}
