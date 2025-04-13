import 'package:firebase_auth/firebase_auth.dart';
import 'package:tune_stack/config/custom_exception.dart';
import 'package:tune_stack/constants/app_strings.dart';
import 'package:tune_stack/helpers/preference_helper.dart';

abstract interface class IAuthRepository {
  Future<User?> loginUser(
    String email,
    String password,
  );

  Future<User?> createUser(
    String email,
    String password,
    String userName,
  );
}

class AuthRepository implements IAuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> loginUser(String email, String password) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await SharedPreferenceHelper.setString(
        AppStrings.userID,
        userCredential.user!.uid,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
        case 'invalid-credential':
          errorMessage = 'Invalid email or password.';
        case 'invalid-email':
          errorMessage = 'Invalid email format.';
        default:
          errorMessage = 'Login failed. Please try again.';
      }

      throw CustomException(errorMessage);
    } catch (e) {
      throw CustomException('Something went wrong, Please try again later');
    }
  }

  @override
  Future<User?> createUser(
    String email,
    String password,
    String userName,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await SharedPreferenceHelper.setString(
        AppStrings.userID,
        userCredential.user!.uid,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      String errorMessage;

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'Email is already in use.';

        default:
          errorMessage = 'Create an account failed. Please try again.';
      }

      throw CustomException(errorMessage);
    } catch (e) {
      throw CustomException('Something went wrong, Please try again later');
    }
  }
}
