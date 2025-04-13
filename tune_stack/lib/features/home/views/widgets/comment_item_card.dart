import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/features/home/model/get_all_comments.dart';

class CommentItem extends StatelessWidget {
  const CommentItem({
    required this.comment,
    super.key,
  });
  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    final avatarText = comment.username.isNotEmpty ? comment.username[0].toUpperCase() : '?';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundColor: AppColors.primary,
            child: Text(
              avatarText,
              style: AppStyles.getBoldStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          AppConst.gap10,
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  comment.username,
                  style: AppStyles.getLightStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text(
                  comment.text,
                  style: AppStyles.getRegularStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
