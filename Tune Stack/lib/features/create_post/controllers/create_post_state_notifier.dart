import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/create_post/controllers/create_post_state.dart';
import 'package:tune_stack/features/create_post/repository/create_post_repository.dart';

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
}
