import 'package:flutter/material.dart';
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/assets.gen.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/widgets/app_divider.dart';

class BackArrowAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BackArrowAppBar({
    required this.title,
    super.key,
    this.onBackPressed,
    this.actions,
    this.isViewDetailsPage = false,
    this.backArrowEnable = true,
    this.centerTitle,
    this.isRspScreen,
  });

  final String title;
  final void Function()? onBackPressed;
  final bool isViewDetailsPage;
  final List<Widget>? actions;
  final bool backArrowEnable;
  final bool? centerTitle;
  final bool? isRspScreen;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: AppDivider(
          height: AppConst.k0,
          dividerColor: AppColors.divider.withValues(alpha: 0.4),
        ),
      ),
      shadowColor: AppColors.divider,
      surfaceTintColor: AppColors.white,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.white,
      automaticallyImplyLeading: false,
      leading: backArrowEnable
          ? IconButton(
              icon: AppAssets.icons.backArrow.svg(
                colorFilter: const ColorFilter.mode(AppColors.primaryText, BlendMode.srcIn),
              ),
              onPressed: onBackPressed ?? NavigationHelper.navigatePop,
            )
          : null,
      leadingWidth: AppConst.k50,
      titleSpacing: backArrowEnable ? AppConst.k0 : AppConst.k16,
      centerTitle: centerTitle ?? true,
      title: Text(
        title,
        style: AppStyles.getBoldStyle(
          color: AppColors.primaryText,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: AppConst.k1.toInt(),
      ),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
