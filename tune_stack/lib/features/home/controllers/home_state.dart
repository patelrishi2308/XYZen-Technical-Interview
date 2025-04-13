import 'package:tune_stack/features/home/model/get_all_posts.dart';

class HomeState {
  HomeState({
    required this.isLoading,
    required this.getAllPostsList,
  });

  HomeState.initial();

  bool isLoading = false;
  List<GetAllPosts> getAllPostsList = [];

  HomeState copyWith({
    bool? isLoading,
    List<GetAllPosts>? getAllPostsList,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      getAllPostsList: getAllPostsList ?? this.getAllPostsList,
    );
  }
}
