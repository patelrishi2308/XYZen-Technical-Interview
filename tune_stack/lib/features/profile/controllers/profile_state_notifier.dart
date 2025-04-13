import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/home/model/get_all_posts.dart';
import 'package:tune_stack/features/home/repository/home_repository.dart';
import 'package:tune_stack/features/profile/controllers/profile_state.dart';
import 'package:tune_stack/features/profile/repository/profile_repository.dart';

final profileStateNotifierProvider = StateNotifierProvider<ProfileStateNotifier, ProfileState>(
  (ref) => ProfileStateNotifier(
    profileRepository: ref.read(_profileRepository),
    homeRepository: ref.read(_homeRepository),
  ),
);

final _profileRepository = Provider((ref) => ProfileRepository());
final _homeRepository = Provider((ref) => HomeRepository());

class ProfileStateNotifier extends StateNotifier<ProfileState> {
  ProfileStateNotifier({
    required this.profileRepository,
    required this.homeRepository,
  }) : super(ProfileState.initial());

  final IProfileRepository profileRepository;
  final IHomeRepository homeRepository;

  Future<List<GetAllPosts>> getAllPostsByUser(String? userId) async {
    if (userId != null) {
      final getAllPosts = await profileRepository.getAllPostByUser(userId);
      return getAllPosts.map(
        (e) {
          return GetAllPosts.fromJson(e);
        },
      ).toList();
    }

    return [];
  }

  Map<String, List<GetAllPosts>> groupPostsByCategory(
    List<GetAllPosts>? posts,
  ) {
    if (posts != null) {
      final grouped = <String, List<GetAllPosts>>{};

      for (final post in posts) {
        final category = post.category;
        if (category == null) continue;

        if (!grouped.containsKey(category)) {
          grouped[category] = [];
        }
        grouped[category]!.add(post);
      }

      return grouped;
    }

    return {};
  }
}
