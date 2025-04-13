import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/features/home/views/widgets/comment_item_card.dart';
import 'package:tune_stack/widgets/app_loading_place_holder.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';

class ViewAllCommentScreen extends ConsumerStatefulWidget {
  const ViewAllCommentScreen({required this.postId, super.key});

  final String postId;

  @override
  ConsumerState<ViewAllCommentScreen> createState() => _ViewAllCommentScreenState();
}

class _ViewAllCommentScreenState extends ConsumerState<ViewAllCommentScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeStateNotifierProvider.notifier).getAllComments(
            widget.postId,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeStateNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const BackArrowAppBar(
        title: 'Comments',
      ),
      body: homeState.isLoading
          ? const AppLoadingPlaceHolder()
          : homeState.commentsList.isEmpty
              ? const Center(
                  child: Text('No comments yet'),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: homeState.commentsList.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final comment = homeState.commentsList[index];
                    return CommentItem(comment: comment);
                  },
                ),
    );
  }
}
