import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dateformat.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/features/auth/views/auth_screen.dart';
import 'package:tune_stack/features/common/debouncer.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/features/home/views/music_player_screen.dart';
import 'package:tune_stack/features/home/views/video_player_screen.dart';
import 'package:tune_stack/features/home/views/view_all_comment_screen.dart';
import 'package:tune_stack/features/home/views/widgets/add_comment_bottom_sheet.dart';
import 'package:tune_stack/features/home/views/widgets/list_item_widget.dart';
import 'package:tune_stack/features/profile/views/profile_screen.dart';
import 'package:tune_stack/helpers/preference_helper.dart';
import 'package:tune_stack/widgets/app_loading_place_holder.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';
import 'package:tune_stack/widgets/no_data_found_widget.dart';
import 'package:tune_stack/widgets/search_field_with_filter_widget.dart';
import 'package:tune_stack/features/chatbot/views/chatbot_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  final searchFocusNode = FocusNode();
  final refreshController = RefreshController();
  final debouncer = Debouncer();

  @override
  void dispose() {
    _searchController.dispose();
    searchFocusNode.dispose();
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeStateNotifierProvider);
    final homeStateNotifier = ref.watch(homeStateNotifierProvider.notifier);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: BackArrowAppBar(
        title: 'TuneStack',
        centerTitle: false,
        backArrowEnable: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline),
            onPressed: () {
              NavigationHelper.navigatePush(
                route: const ChatbotScreen(),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                await SharedPreferenceHelper.clear();
                await FirebaseAuth.instance.signOut();
                await NavigationHelper.navigatePushRemoveUntil(
                  route: const AuthScreen(),
                );
              },
              child: const Icon(Icons.logout),
            ),
          ),

        ],
      ),
      body: Padding(
        padding: AppConst.horizontalPadding.copyWith(top: AppConst.k16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchFieldWithFilterWidget(
              hintText: 'Search by Artist Name',
              searchController: _searchController,
              focusNode: searchFocusNode,
              onClearTap: () async {
                _searchController.text = '';
                searchFocusNode.unfocus();
                homeStateNotifier.searchText('');
                //! Call Function to reset the search
              },
              onChanged: (value) {
                debouncer.run(() {
                  //! Call Function to search
                  homeStateNotifier.searchText(value);
                });
              },
            ),
            AppConst.gap12,
            Expanded(
              child: homeState.isLoading
                  ? const AppLoadingPlaceHolder()
                  : homeState.getAllPostsList.isEmpty
                      ? const Center(
                          child: NoDataFoundWidget(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ListView.separated(
                                key: const PageStorageKey<String>(
                                    'home_post_list'),
                                separatorBuilder: (context, index) =>
                                    AppConst.gap12,
                                padding:
                                    const EdgeInsets.only(bottom: AppConst.k16),
                                itemCount: homeState.getAllPostsList.length,
                                itemBuilder: (context, index) {
                                  final post = homeState.getAllPostsList[index];
                                  return TuneStackListItem(
                                    posterName: post.userName ?? '',
                                    category: post.category ?? '',
                                    imageUrl: post.coverImageUrl ?? '',
                                    // Placeholder for demo
                                    likeCount: post.likeCount ?? 0,
                                    commentCount: 24 + index,
                                    description: post.description ?? '',
                                    getAllPosts: post,
                                    timeAgo: AppDateFormat.getTimeAgo(
                                        int.parse(post.createdAt ?? '0')),
                                    onLikeTap: () {
                                      final getAllPosts =
                                          homeState.getAllPostsList[index];
                                      homeStateNotifier.toggleLike(
                                          getAllPosts.postId, index);
                                    },
                                    onCommentTap: () {
                                      homeStateNotifier.getAllComments(
                                          post.postId,
                                          showLoader: false);
                                      AddCommentBottomSheet.show(
                                        postId: post.postId ?? '',
                                        getAllPosts: post,
                                        index: index,
                                      );
                                    },
                                    onViewAllComment: () {
                                      NavigationHelper.navigatePush(
                                        route: ViewAllCommentScreen(
                                            postId: post.postId ?? ''),
                                      );
                                    },
                                    onProfileTap: () {
                                      NavigationHelper.navigatePush(
                                        route: ProfileScreen(
                                          userId: post.userId,
                                        ),
                                      );
                                    },
                                    onShareTap: () {
                                      homeStateNotifier.shareText(index); // Handle share action
                                    },
                                    onTap: () async {
                                      if (post.fileType == 'Audio') {
                                        await NavigationHelper.navigatePush(
                                          route: MusicPlayerScreen(
                                            musicUrl: post.audioUrl ?? '',
                                            title: post.postTitle ??
                                                'Unknown Track',
                                            artist: post.userName ??
                                                'Unknown Artist',
                                            coverImageUrl:
                                                post.coverImageUrl ?? '',
                                          ),
                                        );
                                      } else {
                                        await NavigationHelper.navigatePush(
                                          route: VideoPlayerScreen(
                                            videoUrl: post.audioUrl ?? '',
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
