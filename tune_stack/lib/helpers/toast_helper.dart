// Package imports:
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/features/common/failure_model.dart';
// Project imports:

class AppToastHelper {
  AppToastHelper._();
  static void showError(String message) {
    _showToast(message, ToastificationType.error);
  }

  static void showSuccess(String message) {
    _showToast(message, ToastificationType.success);
  }

  static void showInfo(String message) {
    _showToast(message, ToastificationType.info);
  }

  static void _showToast(String message, ToastificationType? type) {
    toastification
      ..dismissAll(delayForAnimation: false)
      ..show(
        type: type,
        style: ToastificationStyle.flat,
        autoCloseDuration: const Duration(seconds: 3),
        animationDuration: const Duration(milliseconds: 300),
        showProgressBar: false,
        description: Text(
          message,
          style: AppStyles.getRegularStyle(color: AppColors.primaryText),
          maxLines: AppConst.k5.toInt(),
          overflow: TextOverflow.ellipsis,
        ),
        alignment: Alignment.topCenter,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      );
  }
}

class AppErrorHandler {
  AppErrorHandler._();

  static void showError(Failure failure) {
    AppToastHelper.showError(failure.message);
  }
}
