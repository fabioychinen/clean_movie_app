import 'package:flutter/material.dart';

/// Selo circular com a nota em porcentagem (8.8 → "88%").
class RatingBadge extends StatelessWidget {
  /// Nota de 0 a 10.
  final double voteAverage;

  const RatingBadge({super.key, required this.voteAverage});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.6),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            value: voteAverage / 10,
            backgroundColor: Colors.black12,
            valueColor: AlwaysStoppedAnimation<Color>(_colorFor(voteAverage)),
            strokeWidth: 3,
          ),
        ),
        Text(
          '${(voteAverage * 10).toStringAsFixed(0)}%',
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static Color _colorFor(double voteAverage) {
    if (voteAverage >= 7.0) return Colors.green;
    if (voteAverage >= 4.0) return Colors.yellow;
    return Colors.red;
  }
}
