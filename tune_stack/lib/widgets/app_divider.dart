import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.indent, this.endIndent, this.height, this.thickness, this.dividerColor});

  final double? indent;
  final double? endIndent;
  final double? height;
  final double? thickness;
  final Color? dividerColor;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: dividerColor ?? AppColors.divider,
      thickness: thickness ?? 1,
      indent: indent ?? 0,
      endIndent: endIndent ?? 0,
      height: height ?? 16,
    );
  }
}
