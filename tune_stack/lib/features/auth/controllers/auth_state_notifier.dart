import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tune_stack/features/auth/controllers/auth_state.dart';
import 'package:tune_stack/features/auth/repository/auth_repository.dart';

final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(
    authRepository: ref.read(_authRepository),
  ),
);

final _authRepository = Provider((ref) => AuthRepository());

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier({
    required this.authRepository,
  }) : super(AuthState.initial());

  final IAuthRepository authRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setPasswordFieldFocus({required bool isFocused}) {
    state = state.copyWith(isPasswordFieldFocused: isFocused);
  }

  void onPasswordFieldChange(String value) {
    if (state.isLoginSubmitted) {
      if (value.isEmpty) {
        state = state.copyWith(
          hasPasswordError: true,
          passwordErrorText: 'Please enter a password',
        );
      } else if (value.length < 4) {
        state = state.copyWith(
          hasPasswordError: true,
          passwordErrorText: 'Please enter a password with at least 4 characters',
        );
      } else {
        state = state.copyWith(
          hasPasswordError: false,
          passwordErrorText: '',
        );
      }
    }
  }

  void resetPasswordError() {
    state = state.copyWith(
      hasPasswordError: false,
      passwordErrorText: '',
      hasOTPError: false,
      otpErrorText: '',
      hasConfirmPasswordError: false,
      hasConfirmPasswordErrorText: '',
      isLoginSubmitted: false,
    );
  }

  void setIsLoginSubmitted({required bool value}) {
    state = state.copyWith(isLoginSubmitted: value);
  }

  Future<User?> login(String email, String password) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await authRepository.loginUser(email, password);
      return user;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<User?> createUser(
    String email,
    String password,
    String userName,
  ) async {
    state = state.copyWith(isLoading: true);
    try {
      final user = await authRepository.createUser(email, password, userName);
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'email': email,
          'userName': userName,
          'uid': user.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch,
        });
      }

      return user;
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }
}
