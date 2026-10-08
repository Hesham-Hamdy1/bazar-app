// اختبارات golden: بنرسم كل شاشات فلو Sign in/Sign up على بورد 375x812
// زي تصميم Figma ونقارنها بالملف الذهبي عشان نتأكد إن الرسم مكانش بيتغير.
//
//     flutter test --update-goldens

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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

/// بتفتح [screen] على بورد 375x812 نفسه.
///
/// [size] بيتغيّر للشاشات الأطول من 812 - زي "4. Home" اللي هي 375x1082.
Future<void> _pumpAtArtboardSize(
  WidgetTester tester,
  Widget screen, {
  Size size = const Size(375, 812),
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(MaterialApp(home: screen));
  await tester.pumpAndSettle();
  FocusManager.instance.primaryFocus?.unfocus();
  await tester.pump();
}

/// بتحمّل [assets] فعلاً قبل تصوير الـ golden.
///
/// الاختبار شغال في fake-async فالصور كانت هتطلع بيضا، فبنعدّيها على runAsync الأول.
Future<void> _precacheAssets(WidgetTester tester, List<String> assets) async {
  final BuildContext context = tester.element(find.byType(MaterialApp));
  await tester.runAsync(() async {
    for (final String asset in assets) {
      await precacheImage(AssetImage(asset), context);
    }
  });
  await tester.pump();
}

/// بتكتب `text` في الحقل رقم n من غير focus، عشان الخط البنفسجي متظهرش.
///
/// كمان بننادي `onChanged` عشان الشاشة تعمل setState وتحسب القواعد.
Future<void> _fillField(WidgetTester tester, int index, String text) async {
  final TextField field = tester.widget<TextField>(
    find.byType(TextField).at(index),
  );
  field.controller!.text = text;
  field.onChanged?.call(text);
  await tester.pump();
}

/// بتركّز على الحقل رقم n عشان الخط البنفسجي والـ caret يبقوا جوّه الـ golden.
Future<void> _focusField(WidgetTester tester, int index) async {
  final TextField field = tester.widget<TextField>(
    find.byType(TextField).at(index),
  );
  field.focusNode?.requestFocus();
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadAppFonts);

  testWidgets('1. Spash Screen', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const SplashPage(autoAdvance: false));
    await expectLater(
      find.byType(SplashPage),
      matchesGoldenFile('goldens/1-spash-screen.png'),
    );
  });

  testWidgets('1.1 Onboarding 2', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const OnboardingPage(page: 0));
    await expectLater(
      find.byType(OnboardingPage),
      matchesGoldenFile('goldens/1-1-onboarding-2.png'),
    );
  });

  testWidgets('1.2 Onboarding 3', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const OnboardingPage(page: 1));
    await expectLater(
      find.byType(OnboardingPage),
      matchesGoldenFile('goldens/1-2-onboarding-3.png'),
    );
  });

  testWidgets('1.3 Onboarding 4', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const OnboardingPage(page: 2));
    await expectLater(
      find.byType(OnboardingPage),
      matchesGoldenFile('goldens/1-3-onboarding-4.png'),
    );
  });

  testWidgets('2.0 sign in - empty', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const SignInPage());
    await expectLater(
      find.byType(SignInPage),
      matchesGoldenFile('goldens/2.0_sign_in_empty.png'),
    );
  });

  testWidgets('2.1 sign in - filled', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const SignInPage());
    await _fillField(tester, 0, 'example@email.com');
    await _fillField(tester, 1, 'abc123');
    await expectLater(
      find.byType(SignInPage),
      matchesGoldenFile('goldens/2.1_sign_in_filled.png'),
    );
  });

  testWidgets('2.2 sign up - empty', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const SignUpPage());
    await expectLater(
      find.byType(SignUpPage),
      matchesGoldenFile('goldens/2.2_sign_up_empty.png'),
    );
  });

  testWidgets('2.3 sign up - valid password', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const SignUpPage());
    await _fillField(tester, 0, 'John Doe');
    await _fillField(tester, 1, 'Johndoey@email.com');
    // التصميم بيوضّح 6 نقاط والحقل مش عليه focus.
    await _fillField(tester, 2, 'Abc123');
    await expectLater(
      find.byType(SignUpPage),
      matchesGoldenFile('goldens/2.3_sign_up_valid.png'),
    );
  });

  testWidgets('2.4 sign up - invalid password', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const SignUpPage());
    await _fillField(tester, 0, 'John Doe');
    await _fillField(tester, 1, 'Johndoey@email.com');
    // 5 نقاط وحقل عليه focus: خط بنفسجي وcaret وكتلة القواعد.
    await _fillField(tester, 2, 'Ab1de');
    await _focusField(tester, 2);
    await expectLater(
      find.byType(SignUpPage),
      matchesGoldenFile('goldens/2.4_sign_up_invalid.png'),
    );
  });

  testWidgets('2.5 verification email', (WidgetTester tester) async {
    await _pumpAtArtboardSize(
      tester,
      const VerificationEmailPage(email: 'Johndoe@gmail.com'),
    );
    await expectLater(
      find.byType(VerificationPage),
      matchesGoldenFile('goldens/2.5_verification_email.png'),
    );
  });

  testWidgets('2.6 phone number', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const PhoneNumberPage());
    await expectLater(
      find.byType(PhoneNumberPage),
      matchesGoldenFile('goldens/2.6_phone_number.png'),
    );
  });

  testWidgets('2.7 verification phone', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const VerificationPhonePage());
    await expectLater(
      find.byType(VerificationPage),
      matchesGoldenFile('goldens/2.7_verification_phone.png'),
    );
  });

  testWidgets('2.8 success', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const SuccessPage());
    await expectLater(
      find.byType(SuccessPage),
      matchesGoldenFile('goldens/2.8_success.png'),
    );
  });

  testWidgets('4. Home', (WidgetTester tester) async {
    await _pumpAtArtboardSize(
      tester,
      const HomePage(),
      size: const Size(375, 1082),
    );
    await _precacheAssets(tester, const <String>[
      'assets/figma/home-banner-card.png',
      'assets/figma/home-book-1.png',
      'assets/figma/home-book-2.png',
      'assets/figma/home-book-3.png',
      'assets/figma/home-author-1.png',
      'assets/figma/home-author-2.png',
      'assets/figma/home-author-3.png',
      'assets/figma/home-vendor-1.png',
      'assets/figma/home-vendor-2.png',
      'assets/figma/home-vendor-3.png',
      'assets/figma/home-vendor-4.png',
    ]);
    await expectLater(
      find.byType(HomePage),
      matchesGoldenFile('goldens/4-home.png'),
    );
  });

  testWidgets('4.3 Detail Menu', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const DetailMenuPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/detail-book.png',
      'assets/figma/detail-rating.png',
    ]);
    await expectLater(
      find.byType(DetailMenuPage),
      matchesGoldenFile('goldens/4-3-detail-menu.png'),
    );
  });

  testWidgets('4.2 Home - Set Location', (WidgetTester tester) async {
    await _pumpAtArtboardSize(
      tester,
      const SetLocationPage(),
      size: const Size(375, 909),
    );
    await _precacheAssets(tester, const <String>[
      'assets/figma/loc-icon-back.png',
      'assets/figma/loc-icon-gps.png',
    ]);
    await expectLater(
      find.byType(SetLocationPage),
      matchesGoldenFile('goldens/4-2-home-set-location.png'),
    );
  });

  testWidgets('5 Menu', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const MenuPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/menu-thumb-1.png',
      'assets/figma/menu-thumb-2.png',
      'assets/figma/menu-thumb-3.png',
      'assets/figma/menu-thumb-4.png',
      'assets/figma/menu-icon-home.png',
      'assets/figma/menu-icon-category.png',
    ]);
    await expectLater(
      find.byType(MenuPage),
      matchesGoldenFile('goldens/5-menu.png'),
    );
  });

  testWidgets('5.1 Menu-Search', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const MenuSearchPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/search-field-icon.png',
      'assets/figma/loc-icon-back.png',
      'assets/figma/menu-thumb-1.png',
      'assets/figma/menu-thumb-2.png',
      'assets/figma/menu-thumb-3.png',
      'assets/figma/menu-thumb-4.png',
    ]);
    await expectLater(
      find.byType(MenuSearchPage),
      matchesGoldenFile('goldens/5-1-menu-search.png'),
    );
  });

  testWidgets('9 Profile', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const ProfilePage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/loc-icon-back.png',
      'assets/figma/profile-avatar.png',
      'assets/figma/chevron-right.png',
      'assets/figma/profile-icon-account.png',
      'assets/figma/profile-icon-document.png',
      'assets/figma/profile-icon-chat.png',
      'assets/figma/profile-nav-icon.png',
      'assets/figma/menu-icon-home.png',
    ]);
    await expectLater(
      find.byType(ProfilePage),
      matchesGoldenFile('goldens/9-profile.png'),
    );
  });

  testWidgets('9.1 My Account', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const MyAccountPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/loc-icon-back.png',
    ]);
    await expectLater(
      find.byType(MyAccountPage),
      matchesGoldenFile('goldens/9-1-my-account.png'),
    );
  });

  testWidgets('9.3 Your Favorites', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const FavoritesPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/loc-icon-back.png',
      'assets/figma/menu-thumb-1.png',
      'assets/figma/menu-thumb-2.png',
      'assets/figma/menu-thumb-3.png',
      'assets/figma/menu-thumb-4.png',
    ]);
    await expectLater(
      find.byType(FavoritesPage),
      matchesGoldenFile('goldens/9-3-your-favorites.png'),
    );
  });

  testWidgets('9.4 Order History', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const OrderHistoryPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/loc-icon-back.png',
      'assets/figma/menu-thumb-1.png',
      'assets/figma/menu-thumb-3.png',
    ]);
    await expectLater(
      find.byType(OrderHistoryPage),
      matchesGoldenFile('goldens/9-4-order-history.png'),
    );
  });

  testWidgets('9.5 Help Center', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const HelpCenterPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/help-icon-back.png',
      'assets/figma/help-icon-email.png',
      'assets/figma/help-icon-phone.png',
      'assets/figma/help-wave-emoji.png',
    ]);
    await expectLater(
      find.byType(HelpCenterPage),
      matchesGoldenFile('goldens/9-5-help-center.png'),
    );
  });

  testWidgets('9.6 Logout', (WidgetTester tester) async {
    await _pumpAtArtboardSize(tester, const LogoutPage());
    await _precacheAssets(tester, const <String>[
      'assets/figma/loc-icon-back.png',
      'assets/figma/logout-avatar.png',
      'assets/figma/chevron-right.png',
      'assets/figma/profile-icon-account.png',
      'assets/figma/profile-icon-location.png',
      'assets/figma/profile-icon-document.png',
    ]);
    await expectLater(
      find.byType(LogoutPage),
      matchesGoldenFile('goldens/9-6-logout.png'),
    );
  });
}
