import 'package:tune_stack/features/home/model/get_all_posts.dart';

class ProfileState {
  ProfileState({
    required this.isLoading,
    required this.getAllPostByUser,
    required this.getPostByCar,
  });

  ProfileState.initial();

  bool isLoading = false;
  List<GetAllPosts> getAllPostByUser = [];
  Map<String, List<GetAllPosts>> getPostByCar = {};

  ProfileState copyWith({
    bool? isLoading,
    List<GetAllPosts>? getAllPostByUser,
    Map<String, List<GetAllPosts>>? getPostByCar,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      getAllPostByUser: getAllPostByUser ?? this.getAllPostByUser,
      getPostByCar: getPostByCar ?? this.getPostByCar,
    );
  }
}
