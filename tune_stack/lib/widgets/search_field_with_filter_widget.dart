import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/assets.gen.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/widgets/app_text_field.dart';

class SearchFieldWithFilterWidget extends StatelessWidget {
  const SearchFieldWithFilterWidget({
    required this.hintText,
    required this.searchController,
    super.key,
    this.onFilterTap,
    this.focusNode,
    this.onChanged,
    this.onClearTap,
    this.showFilter = true,
    this.showFilterIndicator = false,
    this.showAddButton,
    this.onAddButtonTap,
  });

  final String hintText;
  final void Function()? onFilterTap;
  final TextEditingController searchController;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final void Function()? onClearTap;
  final bool showFilter;
  final bool showFilterIndicator;
  final bool? showAddButton;
  final void Function()? onAddButtonTap;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppTextField(
            textFieldHeight: AppConst.k46,
            contentPadding: EdgeInsets.zero,
            minLines: AppConst.k1.toInt(),
            maxLines: AppConst.k1.toInt(),
            controller: searchController,
            focusNode: focusNode,
            hintText: hintText,
            prefixIcon: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppAssets.icons.searchIcon.svg(
                    height: AppConst.k18,
                  ),
                ],
              ),
            ),
            onChanged: onChanged,
            suffixIcon: ValueListenableBuilder(
              valueListenable: searchController,
              builder: (context, value, child) => searchController.text.isEmpty
                  ? const SizedBox.shrink()
                  : IconButton(
                      onPressed: onClearTap,
                      icon: const Icon(
                        Icons.clear,
                        color: AppColors.grayMid,
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
