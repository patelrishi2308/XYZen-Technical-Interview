import 'package:flutter/services.dart';

class AppValidation {
  AppValidation._();

  static AppValidation instance = AppValidation._();

  final passWordFormatter = FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9!@#\$&*~]'));
  final emailFormatter = FilteringTextInputFormatter.allow(RegExp('[a-zA-Z0-9@._-]'));
  final digitWithAlphabetFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]'));
  final alphabetFormatter = FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]'));
  final restrictFirstSpace = FilteringTextInputFormatter.deny(RegExp('^ +'));
  final panCardFormatter = FilteringTextInputFormatter.allow(RegExp('[A-Z0-9]'));
  final aadharCardFormatter = FilteringTextInputFormatter.allow(RegExp('[0-9]'));
  final transferStockFormatter = FilteringTextInputFormatter.allow(RegExp(yearsOfExperienceRegex));
  static const String invalidMobileNumberRegex = r'(^[0-9]{10}$)';
  static const String nameRegex = r'^[A-Za-z ]+$';
  static const String phoneNumberRegex = '^[0-5]';
  static const emailRegex = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const accountNumberRegex = r'^\d{6,18}$';
  static const bankNameRegex = r'^[A-Za-z\s.]{3,50}$';
  static const ifscCodeRegex = r'^[A-Z]{4}0[A-Z0-9]{6}$';
  static const addressRegex = r'^[A-Za-z0-9\s.,#-/()]{3,100}$';
  static const postalCodeRegex = r'^\d{6}$';
  static const panNumberRegex = r'^[A-Z]{5}[0-9]{4}[A-Z]$';
  static const aadharNumberRegex = r'^[2-9]{1}[0-9]{11}$';
  static const yearsOfExperienceRegex = r'^[1-9][0-9]*$';

  final numberRegexWithoutZero = FilteringTextInputFormatter.allow(RegExp(r'^[1-9][0-9]*$'));
  final FilteringTextInputFormatter indianPhoneNumberFormatter =
      FilteringTextInputFormatter.allow(RegExp(r'^[6-9]\d{0,9}$'));

  bool isNumeric(String text) {
    return RegExp(r'^[0-9]+$').hasMatch(text);
  }
}
