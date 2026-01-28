import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatelessWidget {
  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.maxWidth = 220,
    this.textAlign = TextAlign.center,
  });

  final String text;
  final TextStyle style;
  final double maxWidth;
  final TextAlign textAlign;

  bool _isOverflowing(double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: maxWidth);

    return painter.didExceedMaxLines;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth,
      child: LayoutBuilder(
        builder: (_, constraints) {
          final overflow = _isOverflowing(constraints.maxWidth);

          if (!overflow) {
            return Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: textAlign,
              style: style,
            );
          }

          return SizedBox(
            height: (style.fontSize ?? 14) * 1.4,
            child: Marquee(
              text: text,
              style: style,
              blankSpace: 40,
              velocity: 45,
              pauseAfterRound: const Duration(seconds: 1),
              startPadding: 10,
              fadingEdgeStartFraction: 0.1,
              fadingEdgeEndFraction: 0.1,
            ),
          );
        },
      ),
    );
  }
}
