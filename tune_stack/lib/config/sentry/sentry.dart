// Dart imports:
import 'dart:async';

import 'package:flutter/material.dart';
// Project imports:
import 'package:tune_stack/config/flavours/app.dart';

class InitSentry {
  Future<void> runAppWithSentry(
    Widget widget, {
    required Environment environment,
  }) async {
    runApp(widget);
  }
}
