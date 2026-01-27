import 'package:flutter/material.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:provider/provider.dart';

class SeekSlider extends StatelessWidget {
  const SeekSlider({super.key});

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();

    final position = music.position.inSeconds.toDouble();
    final duration = music.duration.inSeconds.toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 1),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              activeTrackColor: Colors.white,
              // inactiveTrackColor: Colors.white24,
              // thumbColor: Colors.white,
              // overlayColor: Colors.white.al(0.2),
            ),
            child: Slider(
              min: 0,
              max: duration > 0 ? duration : 1,
              value: position.clamp(0, duration),
              onChanged: (value) {
                music.seek(Duration(seconds: value.toInt()));
              },
            ),
          ),

          // time row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _format(music.position),
                  style: const TextStyle(fontSize: 12),
                ),
                Text(
                  _format(music.duration),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
