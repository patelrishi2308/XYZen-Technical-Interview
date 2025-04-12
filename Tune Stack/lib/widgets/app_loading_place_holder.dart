import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';

class AppLoadingPlaceHolder extends StatelessWidget {
  const AppLoadingPlaceHolder({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppConst.k8),
          boxShadow: const [
            BoxShadow(
              color: AppColors.grayLight,
              blurRadius: AppConst.k8,
              offset: Offset(0, 2),
            ),
          ],
          color: AppColors.white,
        ),
        padding: const EdgeInsets.all(AppConst.k16),
        height: AppConst.k60,
        width: AppConst.k60,
        child: const CircularProgressIndicator(
          color: AppColors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}
