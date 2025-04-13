import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/constants/app_strings.dart';
import 'package:tune_stack/features/create_post/controllers/create_post_state.dart';
import 'package:tune_stack/features/create_post/repository/create_post_repository.dart';
import 'package:tune_stack/helpers/app_utils.dart';
import 'package:tune_stack/helpers/preference_helper.dart';

final createPostStateNotifierProvider = StateNotifierProvider<CreatePostStateNotifier, CreatePostState>(
  (ref) => CreatePostStateNotifier(
    createPostRepository: ref.read(_createPostRepository),
  ),
);

final _createPostRepository = Provider((ref) => CreatePostRepository());

class CreatePostStateNotifier extends StateNotifier<CreatePostState> {
  CreatePostStateNotifier({
    required this.createPostRepository,
  }) : super(CreatePostState.initial());

  final ICreatePostRepository createPostRepository;

  Future<String> uploadCoverImage(File file) async {
    setLoading(true);

    final fileExtension = AppUtils.getExtensionFromPath(file.path);
    final fileName =
        'CoverImage/${SharedPreferenceHelper.getString(AppStrings.userID)}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

    final downloadCoverImageURL = await createPostRepository.uploadCoverImage(file, fileName);
    return downloadCoverImageURL;
  }

  Future<String> uploadMusicFiles(File file) async {
    final fileExtension = AppUtils.getExtensionFromPath(file.path);
    final fileName =
        'Music/${SharedPreferenceHelper.getString(AppStrings.userID)}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

    final downloadCoverImageURL = await createPostRepository.uploadMusic(file, fileName);
    return downloadCoverImageURL;
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<String> createPost(
    String coverImageUrl,
    String postTitle,
    String category,
    String description,
    String audioUrl,
    String uId,
  ) async {
    final createPost = await createPostRepository.createPost(
      coverImageUrl,
      postTitle,
      category,
      description,
      audioUrl,
      uId,
    );

    return createPost;
  }
}
