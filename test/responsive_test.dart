// بندّي كل شاشة عن طريق BazarApp (جذر التطبيق الحقيقي بالـ FixedDesignScaler)
// على مقاسات شاشة تانية غير بورد Figma، ونتأكد إن الرسم مفيهوش overflow
// أو clip أو استثناء والنافذة أصغر (أو أكبر) من التصميم.
//
//     flutter test test/responsive_test.dart

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:bazar_app/main.dart';
import 'package:bazar_app/pages/shop/detail_menu_page.dart';
import 'package:bazar_app/pages/shop/favorites_page.dart';
import 'package:bazar_app/pages/account/help_center_page.dart';
import 'package:bazar_app/pages/shop/home_page.dart';
import 'package:bazar_app/pages/account/logout_page.dart';
import 'package:bazar_app/pages/shop/menu_page.dart';
import 'package:bazar_app/pages/shop/menu_search_page.dart';
import 'package:bazar_app/pages/account/my_account_page.dart';
import 'package:bazar_app/pages/intro/onboarding_page.dart';
import 'package:bazar_app/pages/shop/order_history_page.dart';
import 'package:bazar_app/pages/auth/phone_number_page.dart';
import 'package:bazar_app/pages/account/profile_page.dart';
import 'package:bazar_app/pages/shop/set_location_page.dart';
import 'package:bazar_app/pages/auth/sign_in_page.dart';
import 'package:bazar_app/pages/auth/sign_up_page.dart';
import 'package:bazar_app/pages/intro/splash_page.dart';
import 'package:bazar_app/pages/auth/success_page.dart';
import 'package:bazar_app/pages/auth/verification_email_page.dart';
import 'package:bazar_app/pages/auth/verification_phone_page.dart';
import 'package:bazar_app/pages/auth/verification_page.dart';

import 'test_fonts.dart';

void _noop() {}

void main() {
  setUpAll(loadAppFonts);

  const List<Size> sizes = <Size>[
    Size(375, 812), // بورد Figma نفسه
    Size(320, 568), // أصغر موبايل واقعي (iPhone SE 1)
    Size(360, 640), // أندرويد صغير
    Size(412, 915), // أندرويد طويل حديث
    Size(768, 1024), // تابلت بالطول
  ];

  final Map<String, Widget Function()> screens = <String, Widget Function()>{
    'splash': () => const SplashPage(autoAdvance: false),
    'onboarding': () => const OnboardingPage(page: 0),
    'sign-in': () => const SignInPage(),
    'sign-up': () => const SignUpPage(),
    'phone-number': () => const PhoneNumberPage(),
    'verification': () => VerificationPage(
      title: 'Verification',
      subtitleLead: 'We just sent an OTP to ',
      subtitleTail: 'johndoe@email.com',
      onContinue: _noop,
    ),
    'verification-email': () => const VerificationEmailPage(),
    'verification-phone': () => const VerificationPhonePage(),
    'set-location': () => const SetLocationPage(),
    'success': () => const SuccessPage(),
    'home': () => const HomePage(),
    'menu': () => const MenuPage(),
    'menu-search': () => const MenuSearchPage(),
    'detail-menu': () => const DetailMenuPage(),
    'favorites': () => const FavoritesPage(),
    'order-history': () => const OrderHistoryPage(),
    'profile': () => const ProfilePage(),
    'my-account': () => const MyAccountPage(),
    'help-center': () => const HelpCenterPage(),
    'logout': () => const LogoutPage(),
  };

  for (final MapEntry<String, Widget Function()> screen in screens.entries) {
    for (final Size size in sizes) {
      final String label =
          '${screen.key} @ ${size.width.toInt()}x${size.height.toInt()}';
      testWidgets('fits $label', (WidgetTester tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        // من خلال BazarApp عشان MaterialApp.builder يطبّق الـ scaler
        // بنفس طريقة التطبيق الحقيقي بالظبط.
        await tester.pumpWidget(BazarApp(home: screen.value()));
        await tester.pumpAndSettle();

        // بنسحب كل استثناءات الفريم؛ أي حاجة فاضلة (overflow أو
        // RenderBox assertion ...) تخلّي الاختبار يفشل.
        final List<String> errors = <String>[];
        Object? error;
        while ((error = tester.takeException()) != null) {
          errors.add(error.toString());
        }
        expect(
          errors,
          isEmpty,
          reason: 'layout problems while rendering $label',
        );
      });
    }
  }
}
