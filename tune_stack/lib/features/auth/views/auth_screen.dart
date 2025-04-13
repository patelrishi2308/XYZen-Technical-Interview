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
import 'package:tune_stack/features/auth/views/sign_up_screen.dart';
import 'package:tune_stack/features/bottom_nav_bar/bottom_nav_bar_screen.dart';
import 'package:tune_stack/helpers/app_utils.dart';
import 'package:tune_stack/helpers/toast_helper.dart';
import 'package:tune_stack/widgets/app_button.dart';
import 'package:tune_stack/widgets/app_text_field.dart';
import 'package:tune_stack/widgets/common_container_widget.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.phoneNumber});

  final String? phoneNumber;

  @override
  State<StatefulWidget> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final phoneFocus = FocusNode();
  final passwordFocus = FocusNode();
  final passwordController = TextEditingController();
  ScrollController? scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.phoneNumber != null) {
        phoneController.text = widget.phoneNumber!;
      }
      phoneFocus.addListener(
        () => AppUtils.checkKeyboardVisibility(scrollController),
      );
      passwordFocus.addListener(
        () => AppUtils.checkKeyboardVisibility(scrollController),
      );
    });
  }

  @override
  void dispose() {
    phoneFocus.removeListener(
      () => AppUtils.checkKeyboardVisibility(scrollController),
    );
    passwordFocus.removeListener(
      () => AppUtils.checkKeyboardVisibility(scrollController),
    );
    scrollController?.dispose();
    phoneController.dispose();
    passwordController.dispose();
    phoneFocus.dispose();
    passwordFocus.dispose();
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome to the TuneStack',
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
                              'Email ID',
                              style: AppStyles.getLightStyle(
                                fontSize: AppConst.k14,
                              ),
                            ),
                            AppConst.gap4,
                            AppTextField(
                              focusNode: phoneFocus,
                              controller: phoneController,
                              hintText: 'Enter your email id',
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                AppValidation.instance.emailFormatter,
                              ],
                              validator: ValidationHelper.validateEmail,
                              onFieldSubmitted: (_) {
                                phoneFocus.unfocus();
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
                              obscureText: true,
                              maxLines: 1,
                              textInputAction: TextInputAction.done,
                              onChanged: authStateNotifier.onPasswordFieldChange,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              onFieldSubmitted: (_) {
                                passwordFocus.unfocus();
                              },
                              isSubmitted: authState.isLoginSubmitted,
                            ),
                            AppConst.gap24,
                            AppButton(
                              title: 'Login',
                              isLoading: authState.isLoading,
                              disabledBackgroundColor: AppColors.primary,
                              backgroundColor: AppColors.primary,
                              onPressed: () async {
                                authStateNotifier
                                  ..setIsLoginSubmitted(value: true)
                                  ..onPasswordFieldChange(
                                    passwordController.text,
                                  );
                                final validate = formKey.currentState?.validate() ?? false;
                                if (validate) {
                                  try {
                                    final user = await authStateNotifier.login(
                                      phoneController.text,
                                      passwordController.text,
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
                    "Don't have an account? ",
                    style: AppStyles.getRegularStyle(
                      color: AppColors.white,
                      fontSize: AppConst.k14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      NavigationHelper.navigatePushRemoveUntil(
                        route: const SignUpScreen(),
                      );
                    },
                    child: Text(
                      'Sign Up',
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
    );
  }
}
