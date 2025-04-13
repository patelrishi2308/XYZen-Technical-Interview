// Package imports:
import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  AnalyticsService._();

  static AnalyticsService instance = AnalyticsService._();

  late final FirebaseAnalytics analytics;

  Future<void> init() async {
    analytics = FirebaseAnalytics.instance;

    await analytics.setAnalyticsCollectionEnabled(true);
  }
}
