import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';

class NextSongLabel extends StatelessWidget {
  const NextSongLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerBloc, PlayerState, SongModel?>(
      selector: (state) {
        final queue = state.queue;
        final current = state.currentSong;
        if (queue.isEmpty || current == null) return null;
        final currentIndex = queue.indexWhere((s) => s.id == current.id);
        final nextIndex = currentIndex + 1;
        return nextIndex < queue.length ? queue[nextIndex] : null;
      },
      builder: (context, nextSong) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next up',
                      style: TextStyle(
                        fontSize: 11,
                        // color: Colors.white38,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextSong?.title ?? 'End of queue',
                      style: TextStyle(fontSize: 13, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
