import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/constants/app_validations.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.inputFormatters,
    this.validator,
    this.controller,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.onTap,
    this.maxLength,
    this.border,
    this.enabledBorder,
    this.focusedBorder,
    this.fillColor = AppColors.white,
    this.filled = true,
    this.hintText,
    this.hintStyle,
    this.textStyle,
    this.enabled,
    this.prefixIcon,
    this.focusNode,
    this.onFieldSubmitted,
    this.cursorErrorColor,
    this.showDoneKeyboard = false,
    this.isNextButton = false,
    this.isPrevious = false,
    this.maxLines,
    this.minLines,
    this.disabledBorder,
    this.contentPadding,
    this.textInputAction,
    this.maxLengthEnforcement,
    this.readOnly,
    this.suffixText,
    this.textFieldHeight,
    this.textFieldWidth,
    this.isSubmitted = false,
    this.suffixStyle,
    this.errorStyle,
    this.textCapitalization = TextCapitalization.none,
  });

  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final void Function()? onTap;
  final int? maxLength;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final InputBorder? disabledBorder;
  final Color? fillColor;
  final bool? filled;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final bool? enabled;
  final FocusNode? focusNode;
  final void Function(String)? onFieldSubmitted;
  final Color? cursorErrorColor;
  final bool? showDoneKeyboard;
  final bool isNextButton;
  final bool isPrevious;
  final int? maxLines;
  final int? minLines;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool? readOnly;
  final String? suffixText;
  final double? textFieldHeight;
  final double? textFieldWidth;
  final bool isSubmitted;
  final TextStyle? suffixStyle;
  final TextStyle? errorStyle;
  final TextCapitalization textCapitalization;

  static InputBorder textFieldBorder() {
    return OutlineInputBorder(
      borderSide: const BorderSide(
        color: AppColors.divider,
        width: 0.5,
      ),
      borderRadius: BorderRadius.circular(AppConst.k8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: textFieldHeight,
      width: textFieldWidth ?? AppConst.width,
      child: TextFormField(
        textCapitalization: textCapitalization,
        autovalidateMode: isSubmitted ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
        focusNode: (showDoneKeyboard ?? false) && Platform.isIOS
            ? (focusNode!
              ..addListener(() {
                final hasFocus = focusNode!.hasFocus;
                if (hasFocus) {
                  KeyboardOverlay.showOverlay(
                    context: context,
                    isNextButton: isNextButton,
                    isPrevious: isPrevious,
                    isShowButton: isNextButton || isPrevious,
                  );
                } else {
                  KeyboardOverlay.removeOverlay();
                }
              }))
            : focusNode,
        onFieldSubmitted: onFieldSubmitted,
        maxLength: maxLength,
        maxLines: maxLines,
        minLines: minLines,
        keyboardType: keyboardType,
        onChanged: onChanged,
        enabled: enabled,
        cursorColor: AppColors.primaryText,
        decoration: InputDecoration(
          suffixText: suffixText,
          suffixStyle: suffixStyle,
          hintText: hintText,
          hintStyle: hintStyle ??
              AppStyles.getLightStyle(
                color: AppColors.secondaryText,
                fontSize: AppConst.k14,
              ),
          fillColor: fillColor,
          filled: filled ?? false,
          counterText: '',
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          errorMaxLines: AppConst.k2.toInt(),
          contentPadding: contentPadding ?? const EdgeInsets.symmetric(horizontal: AppConst.k12, vertical: AppConst.k8),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.red,
            ),
            borderRadius: BorderRadius.circular(AppConst.k8),
          ),
          errorStyle: errorStyle ??
              AppStyles.getLightStyle(
                fontSize: AppConst.k12,
                color: AppColors.red,
              ),
          border: border ?? textFieldBorder(),
          enabledBorder: enabledBorder ?? textFieldBorder(),
          disabledBorder: disabledBorder ?? textFieldBorder(),
          focusedBorder: focusedBorder ?? textFieldBorder(),
        ),
        inputFormatters: inputFormatters ??
            [
              AppValidation.instance.restrictFirstSpace,
            ],
        validator: validator,
        controller: controller,
        onTap: onTap,
        cursorErrorColor: cursorErrorColor,
        textInputAction: textInputAction,
        maxLengthEnforcement: maxLengthEnforcement,
        readOnly: readOnly ?? false,
        style: textStyle ??
            AppStyles.getLightStyle(
              fontSize: AppConst.k14,
            ),
      ),
    );
  }
}
