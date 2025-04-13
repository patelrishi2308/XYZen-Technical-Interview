import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_strings.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/features/home/model/get_all_posts.dart';
import 'package:tune_stack/features/home/views/music_player_screen.dart';
import 'package:tune_stack/features/home/views/video_player_screen.dart';
import 'package:tune_stack/features/profile/controllers/profile_state.dart';
import 'package:tune_stack/features/profile/controllers/profile_state_notifier.dart';
import 'package:tune_stack/helpers/preference_helper.dart';
import 'package:tune_stack/widgets/app_loading_place_holder.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({this.userId, super.key});

  final String? userId;

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (widget.userId != null) {
        await ref.read(profileStateNotifierProvider.notifier).getUserByUserId(widget.userId!);
      }
      await _getAllPostByUser();
    });
  }

  Future<void> _getAllPostByUser() async {
    final userId = SharedPreferenceHelper.getString(AppStrings.userID);
    await ref.read(profileStateNotifierProvider.notifier).getAllPostsByUser(widget.userId ?? userId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeStateNotifierProvider);
    final profileState = ref.watch(profileStateNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: BackArrowAppBar(
        title: 'TuneStack',
        centerTitle: (widget.userId ?? '').isNotEmpty,
        backArrowEnable: (widget.userId ?? '').isNotEmpty,
      ),
      body: profileState.isLoading
          ? const AppLoadingPlaceHolder()
          : Column(
              children: [
                // Profile Details Section
                Padding(
                  padding: AppConst.horizontalPadding.copyWith(top: AppConst.k16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.primary,
                        child: Text(
                          (widget.userId ?? '').isNotEmpty
                              ? profileState.userModel?.userName.substring(0, 1) ?? ''
                              : homeState.userModel?.userName.substring(0, 1) ?? '',
                          style: AppStyles.getBoldStyle(
                            fontSize: 25,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      AppConst.gap16,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (widget.userId ?? '').isNotEmpty
                                ? profileState.userModel?.userName ?? ''
                                : homeState.userModel?.userName ?? '',
                            style: AppStyles.getBoldStyle(
                              fontSize: 18,
                              color: AppColors.primaryText,
                            ),
                          ),
                          AppConst.gap4,
                          Text(
                            (widget.userId ?? '').isNotEmpty
                                ? profileState.userModel?.email ?? ''
                                : homeState.userModel?.email ?? '',
                            style: AppStyles.getRegularStyle(
                              fontSize: 14,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                AppConst.gap24,

                // Tab Bar
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(icon: Icon(Icons.grid_on)),
                    Tab(icon: Icon(Icons.view_list)),
                  ],
                  indicatorColor: AppColors.primary,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: AppColors.divider,
                ),

                // Tab Views
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildGridTab(
                        profileState,
                      ),
                      _buildListTab(
                        profileState,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildGridTab(
    ProfileState? profileState,
  ) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConst.k8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: profileState?.getAllPostByUser.length ?? 0,
      itemBuilder: (context, index) {
        final post = profileState?.getAllPostByUser[index];
        return _buildGridItem(post ?? GetAllPosts());
      },
    );
  }

  Widget _buildGridItem(GetAllPosts post) {
    return Container(
      color: Colors.grey[300],
      child: GestureDetector(
        onTap: () async {
          if (post.fileType == 'Audio') {
            await NavigationHelper.navigatePush(
              route: MusicPlayerScreen(
                musicUrl: post.audioUrl ?? '',
                title: post.category ?? 'Unknown Track',
                artist: post.userName ?? 'Unknown Artist',
                coverImageUrl: post.coverImageUrl ?? '',
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
        child: AppNetworkImage(
          url: post.coverImageUrl ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildListTab(
    ProfileState? profileState,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppConst.k16),
      itemCount: profileState?.getPostByCar.keys.toList().length,
      itemBuilder: (context, index) {
        final text = profileState?.getPostByCar.keys.toList()[index] ?? '';
        final capitalizedText = text
            .split(' ')
            .map(
              (word) => word.isNotEmpty ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}' : '',
            )
            .join(' ');
        return _buildCategorySection(
          capitalizedText,
          profileState?.getPostByCar.keys.toList()[index] ?? '',
          profileState,
        );
      },
    );
  }

  Widget _buildCategorySection(String? title, String? category, ProfileState? profileState) {
    final postByCategories = profileState?.getPostByCar[category] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConst.k16,
            vertical: AppConst.k8,
          ),
          child: Text(
            title ?? '',
            style: AppStyles.getBoldStyle(
              fontSize: 18,
              color: AppColors.primaryText,
            ),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConst.k8),
            itemCount: postByCategories.length,
            itemBuilder: (context, index) {
              final post = postByCategories[index];
              return buildHorizontalListItem(post);
            },
          ),
        ),
        AppConst.gap16,
      ],
    );
  }

  Widget buildHorizontalListItem(GetAllPosts post) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: AppConst.k8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConst.k8),
      ),
      child: GestureDetector(
        onTap: () async {
          if (post.fileType == 'Audio') {
            await NavigationHelper.navigatePush(
              route: MusicPlayerScreen(
                musicUrl: post.audioUrl ?? '',
                title: post.category ?? 'Unknown Track',
                artist: post.userName ?? 'Unknown Artist',
                coverImageUrl: post.coverImageUrl ?? '',
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
        child: AppNetworkImage(
          url: post.coverImageUrl ?? '',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
