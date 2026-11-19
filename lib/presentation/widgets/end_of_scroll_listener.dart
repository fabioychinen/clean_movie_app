import 'package:flutter/widgets.dart';

class EndOfScrollListener extends StatelessWidget {
  final VoidCallback? onEndReached;
  final Widget child;

  static const _threshold = 400.0;

  const EndOfScrollListener({
    super.key,
    required this.onEndReached,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final onEndReached = this.onEndReached;
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (onEndReached != null &&
            notification.depth == 0 &&
            notification.metrics.extentAfter < _threshold) {
          onEndReached();
        }
        return false;
      },
      child: child,
    );
  }
}