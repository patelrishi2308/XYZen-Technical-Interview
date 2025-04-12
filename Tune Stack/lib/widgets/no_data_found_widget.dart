import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          message ?? 'No Data Found',
          style: AppStyles.getMediumStyle(
            fontSize: AppConst.k18,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
