class CreatePostState {
  CreatePostState({
    required this.isLoading,
  });

  CreatePostState.initial();

  bool isLoading = false;

  CreatePostState copyWith({
    bool? isLoading,
  }) {
    return CreatePostState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
