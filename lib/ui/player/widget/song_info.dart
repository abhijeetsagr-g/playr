import 'package:flutter/material.dart';
import 'package:playr/core/widget/marquee_text.dart';

class SongInfo extends StatelessWidget {
  const SongInfo({super.key, required this.title, required this.artist});

  final String title;
  final String artist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MarqueeText(
          text: title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          center: true,
        ),
        const SizedBox(height: 4),
        MarqueeText(
          text: artist,
          style: const TextStyle(fontSize: 14),
          center: true,
        ),
      ],
    );
  }
}
