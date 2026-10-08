import 'package:flutter/material.dart';

import '../../routes.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/page_scaffold.dart';
import 'detail_menu_page.dart';
import 'menu_page.dart';

/// شاشة "Search" — وضع البحث في صفحة التصنيف.
/// خانة البحث فوق، وأسفلها نفس صفوف [MenuPage] من غير شريط تنقل ولا أيقونات إضافية.
class MenuSearchPage extends StatelessWidget {
  const MenuSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      children: <Widget>[
        SizedBox(
          width: double.infinity,
          height: AppMetrics.screenHeight,
          child: Stack(
            clipBehavior: Clip.hardEdge,
            children: <Widget>[
              // شريط الأدوات
              Positioned(
                left: 24,
                top: 68,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).maybePop(),
                  child: Image.asset(
                    'assets/figma/loc-icon-back.png',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const Positioned(
                left: 153,
                right: 154,
                top: 66,
                child: Text(
                  'Search',
                  textAlign: TextAlign.center,
                  style: AppText.appBarTitle,
                ),
              ),

              // خانة البحث
              Positioned(
                left: 24,
                right: 24,
                top: 123,
                height: AppMetrics.fieldHeight,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: AppColors.gray50,
                    borderRadius: BorderRadius.circular(AppMetrics.fieldRadius),
                    border: Border.all(color: AppColors.gray200),
                  ),
                ),
              ),
              Positioned(
                left: 40,
                top: 135,
                child: Image.asset(
                  'assets/figma/search-field-icon.png',
                  width: 24,
                  height: 24,
                ),
              ),
              // الـ -1 تصحيح بسيط في الارتفاع عشان النص يظبط مع باقي العناصر.
              const Positioned(
                left: 76,
                top: 134,
                child: Text('Search', style: AppText.body16),
              ),

              // صفوف الكتب
              for (int i = 0; i < MenuPage.rows.length; i++) _row(context, i),
            ],
          ),
        ),
      ],
    );
  }

  /// نفس صف [MenuPage] بس من غير القلب، زي صفحة التصنيف بالظبط.
  Widget _row(BuildContext context, int index) {
    final (String title, String price) = MenuPage.rows[index];
    final double top = 194.0 + 80 * index;
    return Positioned.fill(
      child: GestureDetector(
        behavior: HitTestBehavior.deferToChild,
        onTap: () => Navigator.of(
          context,
        ).push(SlidePageRoute<void>(page: const DetailMenuPage())),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: <Widget>[
            Positioned(
              left: 24,
              top: top + 16,
              child: Image.asset(
                'assets/figma/menu-thumb-${index + 1}.png',
                width: 48,
                height: 48,
              ),
            ),
            Positioned(
              left: 88,
              top: top + 15,
              child: Text(title, style: AppText.body16Medium),
            ),
            Positioned(
              left: 88,
              top: top + 44,
              child: Text(price, style: AppText.seeAll),
            ),
            Positioned(
              left: 0,
              top: top + 79,
              right: 0,
              height: 1,
              child: const ColoredBox(color: AppColors.gray200),
            ),
          ],
        ),
      ),
    );
  }
}
