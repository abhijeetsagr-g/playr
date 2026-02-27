import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';

class NextSongLabel extends StatelessWidget {
  const NextSongLabel({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return StreamBuilder<SongModel?>(
      stream: bloc.currentSong,
      builder: (context, snapshot) {
        final current = snapshot.data;
        final queue = bloc.state.queue;
        SongModel? nextSong;
        if (current != null && queue.isNotEmpty) {
          final currentIndex = queue.indexWhere((s) => s.id == current.id);
          final nextIndex = currentIndex + 1;
          nextSong = nextIndex < queue.length ? queue[nextIndex] : null;
        }
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
                    const Text(
                      'Next up',
                      style: TextStyle(fontSize: 11, letterSpacing: 0.8),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nextSong?.title ?? 'End of queue',
                      style: const TextStyle(fontSize: 13, color: Colors.black),
                      maxLines: 1,
                      overflow: TextOverflow.fade,
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
