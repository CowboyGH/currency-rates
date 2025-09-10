import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            ListTile(
              leading: Icon(Icons.info_outline, color: colorTheme.onSurface),
              title: Text(
                AppStrings.about,
                style: textTheme.body.copyWith(color: colorTheme.onSurface),
              ),
              hoverColor: colorTheme.primary.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onTap: () {
                context.pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: colorTheme.onSurface),
              title: Text(
                AppStrings.history,
                style: textTheme.body.copyWith(color: colorTheme.onSurface),
              ),
              hoverColor: colorTheme.primary.withValues(alpha: 0.1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              onTap: () {
                context.pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
