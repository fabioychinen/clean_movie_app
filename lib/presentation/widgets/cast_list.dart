import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/presentation/layout/fixed_line_text.dart';
import 'package:clean_movie_app/presentation/widgets/profile_photo.dart';
import 'package:flutter/material.dart';

class CastList extends StatelessWidget {
  static const _photoSize = 64.0;
  static const _tileWidth = 90.0;
  static const _spacing = 6.0;
  static const _nameFontSize = 12.0;
  static const _nameMaxLines = 2;
  static const _characterFontSize = 11.0;

  final List<CastMember> cast;

  const CastList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    final height =
        _photoSize +
        _spacing +
        FixedLineText.heightOf(
          context,
          fontSize: _nameFontSize,
          lines: _nameMaxLines,
        ) +
        FixedLineText.heightOf(context, fontSize: _characterFontSize, lines: 1);
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cast.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _CastMemberTile(member: cast[index]),
      ),
    );
  }
}

class _CastMemberTile extends StatelessWidget {
  final CastMember member;

  const _CastMemberTile({required this.member});

  @override
  Widget build(BuildContext context) {
    final character = member.character;
    return SizedBox(
      width: CastList._tileWidth,
      child: Column(
        children: [
          ProfilePhoto(
            profilePath: member.profilePath,
            size: CastList._photoSize,
          ),
          const SizedBox(height: CastList._spacing),
          FixedLineText(
            member.name,
            fontSize: CastList._nameFontSize,
            maxLines: CastList._nameMaxLines,
            fontWeight: FontWeight.bold,
          ),
          if (character != null)
            FixedLineText(
              character,
              fontSize: CastList._characterFontSize,
              maxLines: 1,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}