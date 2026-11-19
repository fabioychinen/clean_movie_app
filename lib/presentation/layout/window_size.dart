import 'package:flutter/widgets.dart';

enum WindowSize {
  compact,
  medium,
  expanded;

  static const _mediumMinWidth = 600.0;
  static const _expandedMinWidth = 840.0;

  static WindowSize of(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= _expandedMinWidth) return expanded;
    if (width >= _mediumMinWidth) return medium;
    return compact;
  }

  static bool isLandscape(BuildContext context) =>
      MediaQuery.orientationOf(context) == Orientation.landscape;
}