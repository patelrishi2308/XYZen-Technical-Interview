// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:tune_stack/config/assets/colors.gen.dart';

class AppTheme {
  /// LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    //! scaffold Background Color
    scaffoldBackgroundColor: AppColors.white,

    //!appbar
    appBarTheme: const AppBarTheme(
      color: AppColors.white,
      elevation: 0,
    ),
  );

  /// DARK THEME
  static final ThemeData darkTheme = ThemeData(
    //! scaffold Background Color
    scaffoldBackgroundColor: AppColors.black,

    //!appbar
    appBarTheme: const AppBarTheme(
      color: AppColors.black,
      elevation: 0,
    ),
  );
}
