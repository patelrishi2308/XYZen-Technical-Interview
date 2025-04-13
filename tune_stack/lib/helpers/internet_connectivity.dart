// Dart imports:
import 'dart:async';

// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:master_utility/master_utility.dart';
// Project imports:
import 'package:tune_stack/constants/app_strings.dart';

class InternetConnectivityHelper extends ChangeNotifier {
  StreamSubscription<ConnectivityResult>? _subscription;

  bool isDeviceConnected = false;
  bool isAlertSet = false;

  final Connectivity _connectivity = Connectivity();

  void init() {
    _getConnectivityType();
    _onInternetConnectionChanged();
  }

  Future<void> _getConnectivityType() async {
    ConnectivityResult connectivityResult;
    try {
      connectivityResult = await _connectivity.checkConnectivity();
      await _checkConnection(connectivityResult);
    } on PlatformException catch (e) {
      LogHelper.logError('$e');
    }
  }

  Future<void> _onInternetConnectionChanged() async {
    _subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) async {
      await _checkConnection(result);
    });
  }

  Future<void> _checkConnection(ConnectivityResult result) async {
    if (result != ConnectivityResult.none) {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      notifyListeners();
    } else {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      notifyListeners();
      if (!isDeviceConnected) {
        showDialogBox();
      }
    }
  }

  Future<void> disposeAppConnectivity() async {
    await _subscription?.cancel();
  }

  void showDialogBox() {
    return DialogHelper.showCustomAlertDialog(
      barrierDismissible: false,
      builder: (BuildContext context, widget) {
        return PopScope(
          onPopInvokedWithResult: (didPop, result) => false,
          child: AlertDialog(
            title: const Text(AppStrings.noInternet),
            content: const Text(AppStrings.checkYourInternet),
            actions: [
              ElevatedButton(
                style: ButtonStyle(
                  elevation: WidgetStateProperty.all(0),
                ),
                onPressed: () {
                  NavigationHelper.navigatePop();
                  isAlertSet = false;
                  notifyListeners();
                  if (!isDeviceConnected && !isAlertSet) {
                    showDialogBox();
                    isAlertSet = true;
                    notifyListeners();
                  }
                },
                child: const Text(AppStrings.tryAgain),
              ),
            ],
          ),
        );
      },
    );
  }
}
