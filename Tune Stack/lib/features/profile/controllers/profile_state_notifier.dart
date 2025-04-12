import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/profile/controllers/profile_state.dart';
import 'package:tune_stack/features/profile/repository/profile_repository.dart';

final profileStateNotifierProvider = StateNotifierProvider<ProfileStateNotifier, ProfileState>(
  (ref) => ProfileStateNotifier(
    profileRepository: ref.read(_profileRepository),
  ),
);

final _profileRepository = Provider((ref) => ProfileRepository());

class ProfileStateNotifier extends StateNotifier<ProfileState> {
  ProfileStateNotifier({
    required this.profileRepository,
  }) : super(ProfileState.initial());

  final IProfileRepository profileRepository;
}
