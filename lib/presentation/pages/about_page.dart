import 'package:clean_movie_app/config/core/constants/api_constants.dart';
import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/presentation/layout/constrained_content.dart';
import 'package:clean_movie_app/presentation/theme/app_theme.dart';
import 'package:clean_movie_app/presentation/utils/open_external_url.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AboutPage extends StatelessWidget {
  static const tmdbLogoAsset = 'assets/images/tmdb_logo.svg';

  const AboutPage({super.key});

  static Future<void> open(BuildContext context) {
    return Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => const AboutPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    return Scaffold(
      appBar: AppBar(title: const Text(CoreStrings.about)),
      body: SafeArea(
        top: false,
        child: ConstrainedContent(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                ),
                child: Column(
                  children: [
                    SvgPicture.asset(
                      tmdbLogoAsset,
                      height: 28,
                      semanticsLabel: 'The Movie Database (TMDB)',
                    ),
                    const SizedBox(height: 20),
                    Text(
                      CoreStrings.tmdbNotice,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      CoreStrings.tmdbNoticeOriginal,
                      textAlign: TextAlign.center,
                      style: mutedStyle,
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed:
                          () => openExternalUrl(
                            context,
                            Uri.parse(ApiConstants.tmdbWebsite),
                          ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 18),
                      label: const Text(CoreStrings.visitTmdb),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                CoreStrings.justWatchAttribution,
                textAlign: TextAlign.center,
                style: mutedStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}