import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/features/home/model/get_all_posts.dart';
import 'package:tune_stack/widgets/app_button.dart';
import 'package:tune_stack/widgets/app_divider.dart';
import 'package:tune_stack/widgets/app_text_field.dart';

class AddCommentBottomSheet extends ConsumerStatefulWidget {
  const AddCommentBottomSheet({
    super.key,
    this.postId,
    this.getAllPosts,
    this.index,
  });

  final String? postId;
  final GetAllPosts? getAllPosts;
  final int? index;

  static void show({
    String? postId,
    GetAllPosts? getAllPosts,
    int? index,
  }) =>
      showModalBottomSheet<void>(
        backgroundColor: AppColors.white,
        context: NavigationService.context,
        builder: (context) => AddCommentBottomSheet(
          postId: postId,
          getAllPosts: getAllPosts,
          index: index,
        ),
        isScrollControlled: true,
      );

  static void hide() => NavigationHelper.navigatePop();

  @override
  ConsumerState<AddCommentBottomSheet> createState() => _AddCommentBottomSheetState();
}

class _AddCommentBottomSheetState extends ConsumerState<AddCommentBottomSheet> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeStateNotifier = ref.watch(homeStateNotifierProvider.notifier);
    return Container(
      padding: EdgeInsets.only(
        bottom: AppConst.viewInsets.bottom + AppConst.k10,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConst.k8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConst.k16,
              vertical: AppConst.k12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Comment',
                  style: AppStyles.getBoldStyle(fontSize: AppConst.k22),
                ),
                GestureDetector(
                  onTap: AddCommentBottomSheet.hide,
                  child: const Icon(
                    Icons.close,
                    color: AppColors.secondaryText,
                  ),
                ),
              ],
            ),
          ),
          const AppDivider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppConst.k12).copyWith(
              top: AppConst.k16,
              bottom: AppConst.viewPadding.bottom,
            ),
            child: Consumer(
              builder: (context, ref, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppTextField(
                      textFieldHeight: AppConst.k100,
                      hintText: 'Enter Your Comment Here',
                      controller: _reasonController,
                      maxLines: AppConst.k4.toInt(),
                      maxLength: AppConst.k100.toInt(),
                    ),
                    //! Buttons
                    AppConst.gap24,
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            title: 'Submit',
                            onPressed: () {
                              homeStateNotifier.addComments(
                                _reasonController.text,
                                widget.index,
                              );
                              AddCommentBottomSheet.hide();
                            },
                          ),
                        ),
                        AppConst.gap16,
                        const Expanded(
                          child: AppButton(
                            elevation: AppConst.k0,
                            title: 'Cancel',
                            onPressed: AddCommentBottomSheet.hide,
                            backgroundColor: AppColors.primaryLight,
                            textColor: AppColors.primary,
                            width: AppConst.k156,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
