import 'package:clean_movie_app/config/core/constants/core_strings.dart';
import 'package:clean_movie_app/config/core/utils/image_url_builder.dart';
import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/presentation/utils/open_external_url.dart';
import 'package:flutter/material.dart';

class WhereToWatch extends StatelessWidget {
  final WatchProviders? providers;

  const WhereToWatch({super.key, required this.providers});

  @override
  Widget build(BuildContext context) {
    final providers = this.providers;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          CoreStrings.whereToWatch,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (providers == null || providers.isEmpty)
          const Text(CoreStrings.notAvailableToWatch)
        else ...[
          for (final (label, options) in [
            (CoreStrings.streaming, providers.streaming),
            (CoreStrings.free, providers.free),
            (CoreStrings.rent, providers.rent),
            (CoreStrings.buy, providers.buy),
          ])
            if (options.isNotEmpty) _ProviderRow(label: label, options: options),
          TextButton(
            onPressed: () => openExternalUrl(context, providers.link),
            child: const Text(CoreStrings.moreWatchOptions),
          ),
        ],
        const Text(
          CoreStrings.justWatchAttribution,
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ProviderRow extends StatelessWidget {
  final String label;
  final List<WatchProvider> options;

  const _ProviderRow({required this.label, required this.options});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          Wrap(
            spacing: 8,
            runSpacing: 8,
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
  final WatchProvider provider;

  const _ProviderLogo({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: provider.name,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          ImageUrlBuilder.tmdb(provider.logoPath, size: 'w92'),
          width: 40,
          height: 40,
          errorBuilder: (_, _, _) => Container(
            width: 40,
            height: 40,
            color: Colors.black12,
            alignment: Alignment.center,
            child: Text(provider.name.characters.first),
          ),
        ),
      ),
    );
  }
}