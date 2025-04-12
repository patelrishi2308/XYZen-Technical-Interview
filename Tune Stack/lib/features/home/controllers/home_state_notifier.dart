import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/home/controllers/home_state.dart';
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
  })  : super(HomeState.initial());

  final IHomeRepository homeRepository;
}
