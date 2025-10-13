import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/common/presentation/widgets/app_drawer_tile.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Боковое меню приложения с пунктами навигации.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  AppStrings.menu,
                  style: textTheme.subtitle.copyWith(color: colorTheme.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            // Декоративный разделитель
            Divider(
              thickness: 1.0,
              indent: 16,
              endIndent: 16,
            ),
            // Пункты меню
            AppDrawerTile(
              title: AppStrings.about,
              onTap: () {
                context.pop();
                context.push('/about');
              },
              icon: Icons.info_outline,
            ),
            AppDrawerTile(
              title: AppStrings.history,
              onTap: () {
                context.pop();
                context.push('/history');
              },
              icon: Icons.history,
            ),
          ],
        ),
      ),
    );
  }
}
