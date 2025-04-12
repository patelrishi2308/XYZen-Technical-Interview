class ProfileState {
  ProfileState({
    required this.isLoading,
  });

  ProfileState.initial();

  bool isLoading = false;

  ProfileState copyWith({
    bool? isLoading,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
