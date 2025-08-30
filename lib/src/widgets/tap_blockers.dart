import 'package:flutter/material.dart';

class TapBlockers extends StatelessWidget {
  final Rect? _holeRect;
  final VoidCallback? _onTap;

  const TapBlockers({Key? key, Rect? holeRect, VoidCallback? onTap})
      : _holeRect = holeRect,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final holeRect = _holeRect;
    if (holeRect == null || holeRect.isEmpty) {
      // If hole is zero, block whole screen.
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {},
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight;

        final double topHeight = holeRect.top;
        final double bottomTop = holeRect.bottom;
        final double bottomHeight = (height - bottomTop).clamp(0.0, height);
        final double leftWidth = holeRect.left;
        final double rightLeft = holeRect.right;
        final double rightWidth = (width - rightLeft).clamp(0.0, width);

        return Stack(
          children: [
            // Top blocker
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              height: topHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onTap: _onTap ?? () {},
              ),
            ),
            // Bottom blocker
            Positioned(
              left: 0,
              top: bottomTop,
              right: 0,
              height: bottomHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onTap: _onTap ?? () {},
              ),
            ),
            // Left blocker (between top and bottom of hole)
            Positioned(
              left: 0,
              top: holeRect.top,
              width: leftWidth,
              height: holeRect.height,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onTap: _onTap ?? () {},
              ),
            ),
            // Right blocker (between top and bottom of hole)
            Positioned(
              left: rightLeft,
              top: holeRect.top,
              width: rightWidth,
              height: holeRect.height,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                excludeFromSemantics: true,
                onTap: _onTap ?? () {},
              ),
            ),
          ],
        );
      },
    );
  }
}
