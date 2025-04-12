import 'dart:async';
import 'dart:ui';

import 'package:tune_stack/constants/app_dimensions.dart';

class Debouncer {
  int? milliseconds;
  VoidCallback? action;
  Timer? timer;

  void run(VoidCallback action) {
    timer?.cancel();
    timer = Timer(
      Duration(milliseconds: AppConst.k500.toInt()),
      action,
    );
  }

  Future<void> search(Future<void> Function() action) async {
    timer?.cancel();
    final completer = Completer<void>();

    timer = Timer(
      Duration(milliseconds: AppConst.k500.toInt()),
      () async {
        await action();
        completer.complete();
      },
    );

    return completer.future;
  }
}
