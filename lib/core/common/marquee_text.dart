import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

class MarqueeText extends StatefulWidget {
  const MarqueeText(
    this.text, {
    super.key,
    required this.style,
    this.maxWidth = 220,
    this.textAlign = TextAlign.center,
    this.number,
  });

  final String text;
  final TextStyle style;
  final double maxWidth;
  final TextAlign textAlign;
  final int? number;

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText> {
  late final bool isOverflowing;

  @override
  void initState() {
    super.initState();
    final painter = TextPainter(
      text: TextSpan(text: widget.text, style: widget.style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();

    isOverflowing = painter.width > widget.maxWidth;
  }

  @override
  Widget build(BuildContext context) {
    if (!isOverflowing) {
      return SizedBox(
        width: widget.maxWidth,
        child: Text(
          widget.text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: widget.textAlign,
          style: widget.style,
        ),
      );
    }

    return SizedBox(
      width: widget.maxWidth,
      height: widget.style.fontSize! * 1.4,
      child: Marquee(
        numberOfRounds: widget.number,
        text: widget.text,
        style: widget.style,
        blankSpace: 40,
        velocity: 45,
        pauseAfterRound: const Duration(seconds: 1),
        startPadding: 10,
        fadingEdgeStartFraction: 0.1,
        fadingEdgeEndFraction: 0.1,
      ),
    );
  }
}
