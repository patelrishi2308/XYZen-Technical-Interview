import 'package:tune_stack/features/common/user_model.dart';
import 'package:tune_stack/features/home/model/get_all_posts.dart';

class ProfileState {
  ProfileState({
    required this.isLoading,
    required this.getAllPostByUser,
    required this.getPostByCar,
    required this.userModel,
  });

  ProfileState.initial();

  bool isLoading = false;
  List<GetAllPosts> getAllPostByUser = [];
  Map<String, List<GetAllPosts>> getPostByCar = {};
  UserModel? userModel;

  ProfileState copyWith({
    bool? isLoading,
    List<GetAllPosts>? getAllPostByUser,
    Map<String, List<GetAllPosts>>? getPostByCar,
    UserModel? userModel,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      getAllPostByUser: getAllPostByUser ?? this.getAllPostByUser,
      getPostByCar: getPostByCar ?? this.getPostByCar,
      userModel: userModel ?? this.userModel,
    );
  }
}
