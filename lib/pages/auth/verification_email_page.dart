import 'package:flutter/material.dart';

import '../../routes.dart';
import 'phone_number_page.dart';
import 'verification_page.dart';

/// شاشة كود التحقق بالإيميل — إطار Figma 2.5.
/// بنكرّر الإيميل اللي اتكتب في شاشة التسجيل، ولو مفيش إيميل نستخدم الافتراضي.
class VerificationEmailPage extends StatelessWidget {
  const VerificationEmailPage({super.key, this.email});

  static const String _demoEmail = 'Johndoe@gmail.com';

  final String? email;

  @override
  Widget build(BuildContext context) {
    final String address = (email == null || email!.isEmpty)
        ? _demoEmail
        : email!;

    return VerificationPage(
      title: 'Verification Email',
      subtitleLead: 'Please enter the code we just sent to email ',
      subtitleTail: address,
      onContinue: () {
        Navigator.of(
          context,
        ).push(SlidePageRoute<void>(page: const PhoneNumberPage()));
      },
    );
  }
}
