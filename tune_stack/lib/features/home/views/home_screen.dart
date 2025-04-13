import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/features/common/debouncer.dart';
import 'package:tune_stack/features/home/controllers/home_state_notifier.dart';
import 'package:tune_stack/features/home/views/widgets/list_item_widget.dart';
import 'package:tune_stack/helpers/smart_refresh/refresh_header.dart';
import 'package:tune_stack/widgets/app_loading_place_holder.dart';
import 'package:tune_stack/widgets/back_arrow_app_bar.dart';
import 'package:tune_stack/widgets/search_field_with_filter_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: const BackArrowAppBar(
        title: 'TuneStack',
        centerTitle: false,
        backArrowEnable: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.favorite_border),
          ),
        ],
      ),
      body: Padding(
        padding: AppConst.horizontalPadding.copyWith(top: AppConst.k16),
        child: Consumer(
          builder: (context, ref, child) {
            final homeState = ref.watch(homeStateNotifierProvider);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SearchFieldWithFilterWidget(
                  hintText: 'Search by Artist Name',
                  searchController: _searchController,
                  focusNode: searchFocusNode,
                  onClearTap: () async {
                    _searchController.text = '';
                    searchFocusNode.unfocus();
                    //! Call Function to reset the search
                  },
                  onChanged: (value) {
                    debouncer.run(() {
                      //! Call Function to search
                    });
                  },
                ),
                AppConst.gap12,
                Expanded(
                  child: homeState.isLoading
                      ? const AppLoadingPlaceHolder()
                      //!TODO: check if data is not empty if empty show this widget
                      // : homeState.feedData.isEmpty
                      //     ? const Center(
                      //         child: NoDataFoundWidget(),
                      //       )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: SmartRefresher(
                                controller: refreshController,
                                onRefresh: () async {
                                  //! Call OnRefresh Function
                                },
                                footer: ClassicFooter(
                                  textStyle: AppStyles.getRegularStyle(
                                    color: AppColors.primary,
                                  ),
                                ),
                                header: const AppWaterDropHeader(),
                                physics: const BouncingScrollPhysics(),
                                //! Enable this once data is there
                                // enablePullUp: customerState.customerData.length > 19,
                                onLoading: () {
                                  //! Call On Loading function
                                },
                                child: ListView.separated(
                                  padding: EdgeInsets.only(bottom: AppConst.k90 + AppConst.bottomPadding),
                                  separatorBuilder: (context, index) => AppConst.gap12,
                                  itemCount: 10,
                                  itemBuilder: (context, index) {
                                    return TuneStackListItem(
                                      posterName: 'Artist Name $index',
                                      category: 'Pop Music',
                                      imageUrl: 'https://picsum.photos/500/500?random=$index', // Placeholder for demo
                                      likeCount: 120 + index,
                                      commentCount: 24 + index,
                                      description:
                                          'This is a great new track I just released! Check it out and let me know what you think.',
                                      timeAgo: '2 hours ago',
                                      onLikeTap: () {
                                        // Handle like action
                                      },
                                      onCommentTap: () {
                                        // Handle comment action
                                      },
                                      onProfileTap: () {
                                        // Handle profile tap
                                      },
                                      onShareTap: () {
                                        // Handle share action
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
