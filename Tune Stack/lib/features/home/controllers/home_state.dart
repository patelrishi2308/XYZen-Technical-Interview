class HomeState {
  HomeState({
    required this.isLoading,
  });

  HomeState.initial();

  bool isLoading = false;

  HomeState copyWith({
    bool? isLoading,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
