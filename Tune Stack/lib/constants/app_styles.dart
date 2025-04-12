import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/config/assets/fonts.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';

class AppStyles {
  static const FontWeight _light = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;
  static const FontWeight _regular = FontWeight.w600;
  static const FontWeight _bold = FontWeight.w700;
  static const FontWeight _extraBold = FontWeight.w900;

  static TextStyle _getTextStyle(
    double fontSize,
    FontWeight fontWeight,
    Color? color,
    TextDecoration? decoration,
    String? fontFamily,
  ) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontFamily: AppFonts.heebo,
      decoration: decoration,
    );
  }

  static TextStyle getLightStyle({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize ?? AppConst.k12,
      _light,
      color ?? AppColors.primaryText,
      decoration,
      fontFamily,
    );
  }

  static TextStyle getMediumStyle({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize ?? AppConst.k12,
      _medium,
      color ?? AppColors.primaryText,
      decoration,
      fontFamily,
    );
  }

  static TextStyle getRegularStyle({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize ?? AppConst.k14,
      _regular,
      color ?? AppColors.primaryText,
      decoration,
      fontFamily,
    );
  }

  static TextStyle getBoldStyle({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize ?? AppConst.k18,
      _bold,
      color ?? AppColors.primaryText,
      decoration,
      fontFamily,
    );
  }

  static TextStyle getExtraBoldStyle({
    double? fontSize,
    Color? color,
    TextDecoration? decoration,
    String? fontFamily,
  }) {
    return _getTextStyle(
      fontSize ?? AppConst.k18,
      _extraBold,
      color ?? AppColors.primaryText,
      decoration,
      fontFamily,
    );
  }
}
