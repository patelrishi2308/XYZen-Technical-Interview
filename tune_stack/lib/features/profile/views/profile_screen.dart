import 'package:flutter/material.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    'J',
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
                      'John Doe',
                      style: AppStyles.getBoldStyle(
                        fontSize: 18,
                        color: AppColors.primaryText,
                      ),
                    ),
                    AppConst.gap4,
                    Text(
                      'john.doe@example.com',
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
      itemCount: 30,
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
    final categories = <String>[
      'Pop',
      'Rock',
      'Hip Hop',
      'Jazz',
      'Classical',
      'Electronic',
      'R&B',
      'Country',
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppConst.k16),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return _buildCategorySection(categories[index]);
      },
    );
  }

  Widget _buildCategorySection(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConst.k16, vertical: AppConst.k8),
          child: Text(
            title,
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
            itemCount: 10,
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
