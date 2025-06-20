class RegisterState {
  final bool isLoading;
  final bool isSuccess;

  const RegisterState({required this.isLoading, required this.isSuccess});

  const RegisterState.initial() : isLoading = false, isSuccess = false;

  RegisterState copyWith({bool? isLoading, bool? isSuccess}) {
    return RegisterState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
