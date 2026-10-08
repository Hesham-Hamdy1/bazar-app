import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/app_text_field.dart';
import '../../shared/or_divider.dart';
import '../../shared/primary_button.dart';
import '../../shared/page_scaffold.dart';
import '../../shared/social_button.dart';
import '../shop/home_page.dart';
import 'sign_up_page.dart';

/// شاشة تسجيل الدخول — إطار Figma 2.0 / 2.1 بمقاس 375×812.
/// الأرقام في التصميم دي إحداثيات y لكل عنصر على الـ art-board.
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _goSignUp() {
    Navigator.of(
      context,
    ).push(SlidePageRoute<void>(page: const SignUpPage()));
  }

  void _goHome() {
    Navigator.of(context).pushAndRemoveUntil(
      SlidePageRoute<void>(page: const HomePage()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      children: <Widget>[
        const SizedBox(height: 116),
        const Gutter(
          dy: 1,
          child: Text('Welcome Back \u{1F44B}', style: AppText.h3),
        ),
        const SizedBox(height: 8),
        const Gutter(
          dy: -1,
          child: Text('Sign to your account', style: AppText.body16),
        ),
        const SizedBox(height: 24),
        Gutter(
          child: AppTextField(
            label: 'Email',
            hint: 'Your email',
            controller: _email,
            focusNode: _emailFocus,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autofillHints: const <String>[AutofillHints.email],
            onSubmitted: (_) => _passwordFocus.requestFocus(),
          ),
        ),
        const SizedBox(height: 16),
        Gutter(
          child: AppTextField(
            label: 'Password',
            hint: 'Your password',
            controller: _password,
            focusNode: _passwordFocus,
            obscureText: true,
            showVisibilityToggle: true,
            textInputAction: TextInputAction.done,
            autofillHints: const <String>[AutofillHints.password],
          ),
        ),
        const SizedBox(height: 16),
        const Gutter(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Forgot Password?', style: AppText.body14Semibold),
          ),
        ),
        const SizedBox(height: 24),
        Gutter(
          child: PrimaryButton(label: 'Login', onPressed: _goHome),
        ),
        const SizedBox(height: 24),
        Gutter(
          child: GestureDetector(
            onTap: _goSignUp,
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: SizedBox(
                width: 243,
                child: Text.rich(
                  TextSpan(
                    style: AppText.body16Medium.copyWith(
                      color: AppColors.gray500,
                    ),
                    children: const <InlineSpan>[
                      TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Sign Up',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        const OrWithDivider(),
        const SizedBox(height: 24),
        const Gutter(
          child: SocialButton(
            label: 'Sign in with Google',
            iconAsset: 'assets/svg/google.svg',
          ),
        ),
        const SizedBox(height: 8),
        const Gutter(
          child: SocialButton(
            label: 'Sign in with Apple',
            iconAsset: 'assets/svg/apple.svg',
          ),
        ),
        const SizedBox(height: 112),
      ],
    );
  }
}
