import 'package:currency_rates/assets/strings/app_strings.dart';
import 'package:currency_rates/features/common/presentation/widgets/show_app_snackbar.dart';
import 'package:currency_rates/uikit/themes/colors/app_color_theme.dart';
import 'package:currency_rates/uikit/themes/text/app_text_theme.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Сторонняя библиотека, используемая в проекте.
class _Library {
  final String name;
  final String version;

  const _Library({required this.name, required this.version});
}

// Список используемых библиотек
final List<_Library> _libraries = [
  const _Library(name: 'bloc_test', version: '^10.0.0'),
  const _Library(name: 'connectivity_plus', version: '^7.0.0'),
  const _Library(name: 'decimal', version: '^3.2.4'),
  const _Library(name: 'dio', version: '^5.9.0'),
  const _Library(name: 'equatable', version: '^2.0.7'),
  const _Library(name: 'file_picker', version: '^10.3.3'),
  const _Library(name: 'flutter_bloc', version: '^9.1.1'),
  const _Library(name: 'get_it', version: '^8.2.0'),
  const _Library(name: 'go_router', version: '^16.2.4'),
  const _Library(name: 'hive', version: '^2.2.3'),
  const _Library(name: 'hive_flutter', version: '^1.1.0'),
  const _Library(name: 'intl', version: '^0.20.2'),
  const _Library(name: 'json_annotation', version: '^4.9.0'),
  const _Library(name: 'mockito', version: '^5.5.0'),
  const _Library(name: 'path', version: '^1.9.1'),
  const _Library(name: 'path_provider', version: '^2.1.5'),
  const _Library(name: 'provider', version: '^6.1.5+1'),
  const _Library(name: 'retrofit', version: '^4.7.3'),
  const _Library(name: 'windows1251', version: '^2.0.1'),
  const _Library(name: 'xml', version: '^6.6.1'),
  const _Library(name: 'url_launcher', version: '^6.3.2'),
];

/// Экран информации о приложении.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<bool> _launchUrl(String url) async {
    try {
      final uri = Uri.parse(url);
      return await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppColorTheme.of(context);
    final textTheme = AppTextTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: colorTheme.surface,
        title: Text(
          AppStrings.about,
          style: textTheme.subtitle.copyWith(color: colorTheme.onBackground),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Название и описание приложения
            _buildHeader(textTheme),
            const SizedBox(height: 16),
            // Карточка с информацией о разработчике
            _buildDeveloperCard(context, textTheme, colorTheme),
            const SizedBox(height: 16),
            // Список используемых библиотек
            Expanded(child: _buildLibrariesList(textTheme, colorTheme)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppTextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.appName,
          style: textTheme.headline,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.appDescription,
          style: textTheme.body,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDeveloperCard(
    BuildContext context,
    AppTextTheme textTheme,
    AppColorTheme colorTheme,
  ) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.developerInfoTitle,
              style: textTheme.subtitle.copyWith(color: colorTheme.onBackground),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Divider(height: 0, color: colorTheme.divider.withValues(alpha: 0.5)),
            ),
            // Информация о разработчике
            Row(
              children: [
                Icon(Icons.person_rounded, color: colorTheme.primary),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(AppStrings.developerName, style: textTheme.body),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () async {
                    final success = await _launchUrl(AppStrings.developerGithubUrl);
                    if (!success && context.mounted) {
                      showAppSnackBar(context, AppStrings.linkFailure);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.link_rounded, color: colorTheme.primary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibrariesList(AppTextTheme textTheme, AppColorTheme colorTheme) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Text(
              AppStrings.usedLibrariesTitle,
              style: textTheme.subtitle.copyWith(color: colorTheme.onBackground),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Divider(height: 0, color: colorTheme.divider.withValues(alpha: 0.5)),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _libraries.length,
              padding: EdgeInsets.zero,
              itemBuilder: (_, index) {
                final lib = _libraries[index];
                return ListTile(
                  leading: Icon(Icons.library_books_rounded, color: colorTheme.primary),
                  title: Text(
                    lib.name,
                    style: textTheme.body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    'версия: ${lib.version}',
                    style: textTheme.caption,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
              separatorBuilder: (_, _) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(
                  height: 0,
                  color: colorTheme.divider.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
