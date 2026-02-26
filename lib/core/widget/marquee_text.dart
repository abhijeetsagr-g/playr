import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatelessWidget {
  const MarqueeText({
    super.key,
    required this.text,
    required this.style,
    this.center = false,
  });

  final String text;
  final TextStyle style;
  final bool center;

  bool _needsMarquee(double maxWidth) {
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(maxWidth: double.infinity);
    return painter.width > maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (style.fontSize ?? 14) + 8,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (_needsMarquee(constraints.maxWidth)) {
            return Marquee(
              text: text,
              style: style,
              scrollAxis: Axis.horizontal,
              blankSpace: 48.0,
              velocity: 40.0,
              pauseAfterRound: const Duration(seconds: 2),
              startPadding: 0,
              fadingEdgeStartFraction: 0.05,
              fadingEdgeEndFraction: 0.05,
            );
          }

          return SizedBox(
            width: constraints.maxWidth,
            child: Text(
              text,
              style: style,
              maxLines: 1,
              textAlign: center ? TextAlign.center : TextAlign.start,
            ),
          );
        },
      ),
    );
  }
}
