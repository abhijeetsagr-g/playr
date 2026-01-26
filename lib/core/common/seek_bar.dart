import 'package:flutter/material.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:provider/provider.dart';

class SeekBar extends StatelessWidget {
  const SeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    final music = context.read<MusicProvider>();

    return StreamBuilder<Duration?>(
      stream: music.durationStream,
      builder: (context, durationSnap) {
        final duration = durationSnap.data ?? Duration.zero;

        return StreamBuilder<Duration>(
          stream: music.positionStream,
          builder: (context, positionSnap) {
            final position = positionSnap.data ?? Duration.zero;

            final max = duration.inMilliseconds.toDouble();
            final value = position.inMilliseconds.clamp(0, max).toDouble();

            return Column(
              children: [
                Slider(
                  min: 0,
                  max: max > 0 ? max : 1,
                  value: value,
                  onChanged: (v) {
                    music.seek(Duration(milliseconds: v.toInt()));
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(_fmt(position)), Text(_fmt(duration))],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
