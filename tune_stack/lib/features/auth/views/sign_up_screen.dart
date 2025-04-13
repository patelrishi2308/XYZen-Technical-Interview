import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:master_utility/master_utility.dart';
import 'package:tune_stack/config/assets/colors.gen.dart';
import 'package:tune_stack/config/custom_exception.dart';
import 'package:tune_stack/constants/app_dimensions.dart';
import 'package:tune_stack/constants/app_styles.dart';
import 'package:tune_stack/constants/app_validations.dart';
import 'package:tune_stack/features/auth/controllers/auth_state_notifier.dart';
import 'package:tune_stack/features/auth/views/auth_screen.dart';
import 'package:tune_stack/features/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:tune_stack/helpers/app_utils.dart';
import 'package:tune_stack/helpers/toast_helper.dart';
import 'package:tune_stack/widgets/app_button.dart';
import 'package:tune_stack/widgets/app_text_field.dart';
import 'package:tune_stack/widgets/common_container_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  State<StatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final nameFocus = FocusNode();
  final emailController = TextEditingController();
  final emailFocus = FocusNode();
  final passwordController = TextEditingController();
  final passwordFocus = FocusNode();
  final confirmPasswordController = TextEditingController();
  final confirmPasswordFocus = FocusNode();
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.phoneNumber != null) {
        emailController.text = widget.phoneNumber!;
      }
      nameFocus.addListener(
        () => AppUtils.checkKeyboardVisibility(scrollController),
      );
      emailFocus.addListener(
        () => AppUtils.checkKeyboardVisibility(scrollController),
      );
      passwordFocus.addListener(
        () => AppUtils.checkKeyboardVisibility(scrollController),
      );
      confirmPasswordFocus.addListener(
        () => AppUtils.checkKeyboardVisibility(scrollController),
      );
    });
  }

  @override
  void dispose() {
    nameFocus.removeListener(
      () => AppUtils.checkKeyboardVisibility(scrollController),
    );
    emailFocus.removeListener(
      () => AppUtils.checkKeyboardVisibility(scrollController),
    );
    passwordFocus.removeListener(
      () => AppUtils.checkKeyboardVisibility(scrollController),
    );
    confirmPasswordFocus.removeListener(
      () => AppUtils.checkKeyboardVisibility(scrollController),
    );
    scrollController?.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    confirmPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: AppColors.scaffoldBg,
        systemNavigationBarDividerColor: AppColors.scaffoldBg,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light, // light == black status bar for IOS.
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: AppConst.k48),
                Text(
                  'Create Your Account',
                  style: AppStyles.getBoldStyle(
                    color: AppColors.white,
                    fontSize: AppConst.k24,
                  ),
                ),
                AppConst.gap24,
                CommonContainerWidget(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppConst.k24),
                  margin: const EdgeInsets.symmetric(horizontal: AppConst.k16),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppConst.k8),
                    bottomLeft: Radius.circular(AppConst.k8),
                    bottomRight: Radius.circular(AppConst.k8),
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final authState = ref.watch(authStateNotifierProvider);
                      final authStateNotifier = ref.read(authStateNotifierProvider.notifier);
                      return Form(
                        key: formKey,
                        child: IgnorePointer(
                          ignoring: authState.isLoading || authState.isGeneratePasswordLoading,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Full Name',
                                style: AppStyles.getLightStyle(
                                  fontSize: AppConst.k14,
                                ),
                              ),
                              AppConst.gap4,
                              AppTextField(
                                focusNode: nameFocus,
                                controller: nameController,
                                hintText: 'Enter your full name',
                                keyboardType: TextInputType.name,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your name';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  nameFocus.unfocus();
                                  FocusScope.of(context).requestFocus(emailFocus);
                                },
                                isSubmitted: authState.isLoginSubmitted,
                              ),
                              AppConst.gap24,
                              Text(
                                'Email ID',
                                style: AppStyles.getLightStyle(
                                  fontSize: AppConst.k14,
                                ),
                              ),
                              AppConst.gap4,
                              AppTextField(
                                focusNode: emailFocus,
                                controller: emailController,
                                hintText: 'Enter your email id',
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  AppValidation.instance.emailFormatter,
                                ],
                                validator: ValidationHelper.validateEmail,
                                onFieldSubmitted: (_) {
                                  emailFocus.unfocus();
                                  FocusScope.of(context).requestFocus(passwordFocus);
                                },
                                isSubmitted: authState.isLoginSubmitted,
                              ),
                              AppConst.gap24,
                              Text(
                                'Password',
                                style: AppStyles.getLightStyle(
                                  fontSize: AppConst.k14,
                                ),
                              ),
                              AppConst.gap4,
                              AppTextField(
                                focusNode: passwordFocus,
                                controller: passwordController,
                                hintText: 'Enter your password',
                                textInputAction: TextInputAction.next,
                                onChanged: authStateNotifier.onPasswordFieldChange,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  if (value.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  passwordFocus.unfocus();
                                  FocusScope.of(context).requestFocus(confirmPasswordFocus);
                                },
                                isSubmitted: authState.isLoginSubmitted,
                              ),
                              AppConst.gap24,
                              Text(
                                'Confirm Password',
                                style: AppStyles.getLightStyle(
                                  fontSize: AppConst.k14,
                                ),
                              ),
                              AppConst.gap4,
                              AppTextField(
                                focusNode: confirmPasswordFocus,
                                controller: confirmPasswordController,
                                hintText: 'Confirm your password',
                                textInputAction: TextInputAction.done,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  confirmPasswordFocus.unfocus();
                                },
                                isSubmitted: authState.isLoginSubmitted,
                              ),
                              AppConst.gap32,
                              AppButton(
                                title: 'Sign Up',
                                isLoading: authState.isLoading,
                                disabledBackgroundColor: AppColors.primary,
                                backgroundColor: AppColors.primary,
                                onPressed: () async {
                                  authStateNotifier.setIsLoginSubmitted(
                                    value: true,
                                  );
                                  final validate = formKey.currentState?.validate() ?? false;
                                  if (validate) {
                                    try {
                                      final user = await authStateNotifier.createUser(
                                        emailController.text,
                                        passwordController.text,
                                        nameController.text,
                                      );

                                      if (user != null) {
                                        await NavigationHelper.navigatePushRemoveUntil(
                                          route: const BottomNavBarScreen(),
                                        );
                                      }
                                    } catch (e) {
                                      if (e is CustomException) {
                                        AppToastHelper.showError(e.message);
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                AppConst.gap24,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: AppStyles.getRegularStyle(
                        color: AppColors.white,
                        fontSize: AppConst.k14,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationHelper.navigatePush(
                          route: const AuthScreen(),
                        );
                      },
                      child: Text(
                        'Login',
                        style: AppStyles.getBoldStyle(
                          color: AppColors.white,
                          fontSize: AppConst.k14,
                        ),
                      ),
                    ),
                  ],
                ),
                AppConst.gap24,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
