import 'package:tune_stack/features/common/user_model.dart';
import 'package:tune_stack/features/home/model/get_all_comments.dart';
import 'package:tune_stack/features/home/model/get_all_posts.dart';

class HomeState {
  HomeState({
    required this.isLoading,
    required this.getAllPostsList,
    required this.userModel,
    required this.commentsList,
  });

  HomeState.initial();

  bool isLoading = false;
  List<GetAllPosts> getAllPostsList = [];
  List<CommentModel> commentsList = [];
  UserModel? userModel;

  HomeState copyWith({
    bool? isLoading,
    List<GetAllPosts>? getAllPostsList,
    List<CommentModel>? commentsList,
    UserModel? userModel,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      getAllPostsList: getAllPostsList ?? this.getAllPostsList,
      userModel: userModel ?? this.userModel,
      commentsList: commentsList ?? this.commentsList,
    );
  }
}
