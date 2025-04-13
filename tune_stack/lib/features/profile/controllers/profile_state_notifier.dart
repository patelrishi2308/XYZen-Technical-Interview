import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/common/user_model.dart';
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
    state = state.copyWith(isLoading: true);
    if (userId != null) {
      final getAllPosts = await profileRepository.getAllPostByUser(userId);
      final getAllPostByUser = getAllPosts.map(
        (e) {
          return GetAllPosts.fromJson(e);
        },
      ).toList();
      state = state.copyWith(getAllPostByUser: getAllPostByUser);
      groupPostsByCategory();
    }
    state = state.copyWith(isLoading: false);

    return [];
  }

  Map<String, List<GetAllPosts>> groupPostsByCategory() {
    final grouped = <String, List<GetAllPosts>>{};

    for (final post in state.getAllPostByUser) {
      final category = post.category;
      if (category == null) continue;

      if (!grouped.containsKey(category)) {
        grouped[category] = [];
      }
      grouped[category]!.add(post);
    }

    state = state.copyWith(getPostByCar: grouped);
    return grouped;
  }

  Future<void> getUserByUserId(String userId) async {
    state = state.copyWith(isLoading: true);
    try {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        final userDataMap = userDoc.data()!;
        final userModel = UserModel.fromMap(userDataMap);
        state = state.copyWith(userModel: userModel);
      } else {
        debugPrint('User not found');
      }
      state = state.copyWith(isLoading: false);
    } catch (e) {
      debugPrint('Error getting user: $e');
      state = state.copyWith(isLoading: false);
    }
  }
}
