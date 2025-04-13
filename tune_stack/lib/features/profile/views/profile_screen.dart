import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_strings.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/features/common/user_model.dart';
import 'package:tune_stack/features/home/controllers/home_state.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/features/profile/controllers/profile_state.dart';
import 'package:tune_stack/features/profile/controllers/profile_state_notifier.dart';
import 'package:tune_stack/helpers/preference_helper.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  /*List<GetAllPosts>? getAllPostByUser = [];
  Map<String, List<GetAllPosts>> groupedByCategory = {};*/
  ProfileStateNotifier? profileStateNotifier;
  ProfileState? createPostState;
  HomeStateNotifier? homeStateNotifier;
  HomeState? homeState;
  UserModel? userModel;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    /*profileStateNotifier = ref.read(profileStateNotifierProvider.notifier);
    createPostState = ref.watch(profileStateNotifierProvider);*/

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        _getAllPostByUser();
      },
    );
  }

  Future<void> _getAllPostByUser() async {
    final userId = SharedPreferenceHelper.getString(AppStrings.userID);
    await profileStateNotifier?.getAllPostsByUser(userId);
    /*profileStateNotifier?.groupPostsByCategory() ?? {};*/
    /*setState(() {});*/
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userModel = ref.read(homeStateNotifierProvider).userModel;
    homeStateNotifier = ref.watch(homeStateNotifierProvider.notifier);
    homeState = ref.watch(homeStateNotifierProvider);
    profileStateNotifier = ref.watch(profileStateNotifierProvider.notifier);
    createPostState = ref.watch(profileStateNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const BackArrowAppBar(
        title: 'TuneStack',
        centerTitle: false,
        backArrowEnable: false,
      ),
      body: Column(
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
                    userModel?.userName.substring(0, 1) ?? '',
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
                      userModel?.userName ?? '',
                      style: AppStyles.getBoldStyle(
                        fontSize: 18,
                        color: AppColors.primaryText,
                      ),
                    ),
                    AppConst.gap4,
                    Text(
                      userModel?.email ?? '',
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
                _buildGridTab(),
                _buildListTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(AppConst.k8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
      ),
      itemCount: createPostState?.getAllPostByUser.length ?? 0,
      itemBuilder: (context, index) {
        return _buildGridItem(index);
      },
    );
  }

  Widget _buildGridItem(int index) {
    return Container(
      color: Colors.grey[300],
      child: ColoredBox(
        color: index.isEven ? AppColors.primary.withValues(alpha: 0.7) : AppColors.primary.withValues(alpha: 0.5),
        child: const Center(
          child: Icon(
            Icons.music_note,
            color: AppColors.white,
            size: 30,
          ),
        ),
      ),
    );
  }

  Widget _buildListTab() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppConst.k16),
      itemCount: createPostState?.getPostByCar.keys.toList().length,
      itemBuilder: (context, index) {
        return _buildCategorySection(createPostState?.getPostByCar.keys.toList()[index]);
      },
    );
  }

  Widget _buildCategorySection(String? title) {
    final postByCategories = createPostState?.getPostByCar[title] ?? [];

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
              return _buildHorizontalListItem(index);
            },
          ),
        ),
        AppConst.gap16,
      ],
    );
  }

  Widget _buildHorizontalListItem(int index) {
    return Container(
      width: 120,
      margin: const EdgeInsets.symmetric(horizontal: AppConst.k8),
      decoration: BoxDecoration(
        color: index.isEven ? AppColors.primary.withValues(alpha: 0.7) : AppColors.primary.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppConst.k8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.music_note,
            color: AppColors.white,
            size: 40,
          ),
          AppConst.gap8,
          Text(
            'Item ${index + 1}',
            style: AppStyles.getMediumStyle(
              fontSize: 14,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
