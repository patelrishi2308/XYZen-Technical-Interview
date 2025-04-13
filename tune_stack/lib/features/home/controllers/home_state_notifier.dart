import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/home/controllers/home_state.dart';
import 'package:tune_stack/features/home/model/get_all_posts.dart';
import 'package:tune_stack/features/home/repository/home_repository.dart';

final homeStateNotifierProvider = StateNotifierProvider<HomeStateNotifier, HomeState>(
  (ref) => HomeStateNotifier(
    homeRepository: ref.read(_homeRepository),
  ),
);

final _homeRepository = Provider((ref) => HomeRepository());

class HomeStateNotifier extends StateNotifier<HomeState> {
  HomeStateNotifier({
    required this.homeRepository,
  }) : super(HomeState.initial());

  final IHomeRepository homeRepository;

  Future<void> getAllPosts() async {
    state = state.copyWith(isLoading: true);
    final getAllPosts = await homeRepository.getAllPost();
    state = state.copyWith(isLoading: false);
    if (getAllPosts.isNotEmpty) {
      final getAllPostsList = getAllPosts.map(GetAllPosts.fromJson).toList().reversed.toList();
      state = state.copyWith(getAllPostsList: getAllPostsList);
    } else {
      state = state.copyWith(getAllPostsList: []);
    }
  }
}
