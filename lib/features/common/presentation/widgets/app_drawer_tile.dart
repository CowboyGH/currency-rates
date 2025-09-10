import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';

class AppDrawerTile extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData icon;
  const AppDrawerTile({super.key, required this.title, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);
    return ListTile(
      leading: Icon(icon, color: colorTheme.onSurface),
      title: Text(
        title,
        style: textTheme.body.copyWith(color: colorTheme.onSurface),
      ),
      hoverColor: colorTheme.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      onTap: onTap,
    );
  }
}
