class AuthState {
  AuthState({
    required this.isLoading,
    required this.isGeneratePasswordLoading,
    required this.isLoginEnable,
    required this.isPasswordFieldFocused,
    required this.isLoginSubmitted,
    required this.hasPasswordError,
    required this.passwordErrorText,
    required this.hasOTPError,
    required this.otpErrorText,
    required this.hasConfirmPasswordError,
    required this.hasConfirmPasswordErrorText,
    this.otp,
  });

  AuthState.initial();

  bool isLoading = false;
  bool isGeneratePasswordLoading = false;
  String? otp;
  bool isLoginEnable = false;
  bool isPasswordFieldFocused = false;
  bool isLoginSubmitted = false;
  bool hasOTPError = false;
  String otpErrorText = '';
  bool hasPasswordError = false;
  String passwordErrorText = '';
  bool hasConfirmPasswordError = false;
  String hasConfirmPasswordErrorText = '';

  AuthState copyWith({
    bool? isLoading,
    bool? isLoginEnable,
    bool? isGeneratePasswordLoading,
    bool? isPasswordFieldFocused,
    bool? isLoginSubmitted,
    bool? hasPasswordError,
    String? passwordErrorText,
    bool? hasOTPError,
    String? otpErrorText,
    bool? hasConfirmPasswordError,
    String? hasConfirmPasswordErrorText,
    String? otp,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      isLoginEnable: isLoginEnable ?? this.isLoginEnable,
      isGeneratePasswordLoading: isGeneratePasswordLoading ?? this.isGeneratePasswordLoading,
      isPasswordFieldFocused: isPasswordFieldFocused ?? this.isPasswordFieldFocused,
      isLoginSubmitted: isLoginSubmitted ?? this.isLoginSubmitted,
      hasOTPError: hasOTPError ?? this.hasOTPError,
      otpErrorText: otpErrorText ?? this.otpErrorText,
      hasPasswordError: hasPasswordError ?? this.hasPasswordError,
      passwordErrorText: passwordErrorText ?? this.passwordErrorText,
      hasConfirmPasswordError: hasConfirmPasswordError ?? this.hasConfirmPasswordError,
      hasConfirmPasswordErrorText: hasConfirmPasswordErrorText ?? this.hasConfirmPasswordErrorText,
      otp: otp ?? this.otp,
    );
  }
}
