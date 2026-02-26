import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';
import 'package:playr/ui/player/view/player_view.dart';
import 'package:playr/ui/player/widget/album_art.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerBloc, PlayerState, (SongModel?, bool)>(
      selector: (state) => (state.currentSong, state.isPlaying),
      builder: (context, data) {
        final (song, isPlaying) = data;

        if (song == null) return const SizedBox.shrink();

        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PlayerView()),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                // Album art
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: 44,
                    height: 44,
                    child: AlbumArt(song: song),
                  ),
                ),
                const SizedBox(width: 12),

                // Title & artist
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        song.artist ?? 'Unknown Artist',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),

                // Prev
                IconButton(
                  icon: const Icon(Icons.skip_previous_rounded),
                  onPressed: () => context.read<PlayerBloc>().add(SkipPrev()),
                  style: IconButton.styleFrom(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
                // Play/Pause
                IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  ),
                  onPressed: () =>
                      context.read<PlayerBloc>().add(TogglePlayPause()),
                ),

                // Next
                IconButton(
                  icon: const Icon(Icons.skip_next_rounded),
                  onPressed: () => context.read<PlayerBloc>().add(SkipNext()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
