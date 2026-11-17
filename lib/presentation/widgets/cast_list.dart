import 'package:clean_movie_app/domain/entities/movie_details.dart';
import 'package:clean_movie_app/presentation/widgets/profile_photo.dart';
import 'package:flutter/material.dart';

class CastList extends StatelessWidget {
  final List<CastMember> cast;

  const CastList({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
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
      width: 90,
      child: Column(
        children: [
          ProfilePhoto(profilePath: member.profilePath),
          const SizedBox(height: 6),
          Text(
            member.name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          if (character != null)
            Text(
              character,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}