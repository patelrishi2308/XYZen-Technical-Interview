import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    this.onPressed,
    super.key,
    this.width,
    this.padding,
    this.isLoading = false,
    this.margin = EdgeInsets.zero,
    this.isEnabled = true,
    this.title,
    this.textColor,
    this.elevation,
    this.backgroundColor,
    this.height,
    this.enableIcon,
    this.iconWidget,
    this.fontSize,
    this.side,
    this.borderRadius,
    this.borderRadiusGeometry,
    this.disabledBackgroundColor,
    this.gap,
    this.disabledTextColor,
  });

  final double? width;
  final double? height;
  final EdgeInsetsGeometry margin;
  final String? title;
  final VoidCallback? onPressed;
  final bool isEnabled;
  final Color? textColor;
  final double? elevation;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final EdgeInsetsGeometry? padding;
  final bool? enableIcon;
  final Widget? iconWidget;
  final double? fontSize;
  final BorderSide? side;
  final double? borderRadius;
  final BorderRadiusGeometry? borderRadiusGeometry;
  final Gap? gap;
  final Color? disabledTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? AppConst.width,
      height: height ?? AppConst.k44,
      margin: margin,
      child: AbsorbPointer(
        absorbing: !isEnabled,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: padding,
            elevation: elevation,
            backgroundColor: backgroundColor ?? AppColors.primary,
            disabledBackgroundColor: disabledBackgroundColor ?? AppColors.primary.withValues(alpha: 0.5),
            shape: RoundedRectangleBorder(
              borderRadius: borderRadiusGeometry ??
                  BorderRadius.circular(
                    borderRadius ?? AppConst.k8,
                  ),
              side: side ?? BorderSide.none,
            ),
          ),
          onPressed: isLoading ? null : (isEnabled ? onPressed : null),
          child: (isLoading
              ? const SizedBox(
                  height: AppConst.k20,
                  width: AppConst.k20,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: AppConst.k3,
                  ),
                )
              : enableIcon ?? false
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        iconWidget ?? const SizedBox(),
                        gap ?? AppConst.gap5,
                        Text(
                          title ?? '',
                          style: AppStyles.getBoldStyle(
                            color: textColor ?? AppColors.white,
                            fontSize: fontSize ?? AppConst.k16,
                          ),
                          maxLines: AppConst.k1.toInt(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    )
                  : Text(
                      title ?? '',
                      textAlign: TextAlign.center,
                      style: AppStyles.getBoldStyle(
                        color: !isEnabled ? disabledTextColor ?? AppColors.white : textColor ?? AppColors.white,
                        fontSize: fontSize ?? AppConst.k16,
                      ),
                      maxLines: AppConst.k1.toInt(),
                      overflow: TextOverflow.ellipsis,
                    )),
        ),
      ),
    );
  }
}
