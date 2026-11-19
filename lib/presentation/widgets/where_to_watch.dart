import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/config/core/utils/image_url_builder.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/presentation/theme/app_theme.dart';
import 'package:clean_movie_app/presentation/utils/open_external_url.dart';
import 'package:flutter/material.dart';

class WhereToWatch extends StatelessWidget {
  final WatchProviders? providers;

  const WhereToWatch({super.key, required this.providers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final providers = this.providers;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (providers == null || providers.isEmpty)
            const Text(CoreStrings.notAvailableToWatch)
          else ...[
            for (final (label, options) in [
              (CoreStrings.streaming, providers.streaming),
              (CoreStrings.free, providers.free),
              (CoreStrings.rent, providers.rent),
              (CoreStrings.buy, providers.buy),
            ])
              if (options.isNotEmpty)
                _ProviderRow(label: label, options: options),
            TextButton.icon(
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
              onPressed: () => openExternalUrl(context, providers.link),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text(CoreStrings.moreWatchOptions),
            ),
          ],
          const SizedBox(height: 4),
          Text(
            CoreStrings.justWatchAttribution,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProviderRow extends StatelessWidget {
  final String label;
  final List<WatchProvider> options;

  const _ProviderRow({required this.label, required this.options});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              for (final provider in options) _ProviderLogo(provider: provider),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProviderLogo extends StatelessWidget {
  static const _size = 44.0;

  final WatchProvider provider;

  const _ProviderLogo({required this.provider});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Tooltip(
      message: provider.name,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          ImageUrlBuilder.tmdb(provider.logoPath, size: TmdbImageSize.logo),
          width: _size,
          height: _size,
          errorBuilder:
              (_, _, _) => Container(
                width: _size,
                height: _size,
                color: colors.surfaceContainerHighest,
                alignment: Alignment.center,
                child: Text(provider.name.characters.first),
              ),
        ),
      ),
    );
  }
}