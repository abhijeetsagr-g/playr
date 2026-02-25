import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/core/utils/song_to_media_item.dart';
import 'package:playr/logic/provider/audio_providers.dart';
import 'package:playr/ui/player/view/player_view.dart';

class SongList extends ConsumerWidget {
  const SongList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songsAsync = ref.watch(songListProvider(SongSortType.TITLE));
    final playback = ref.watch(playbackServiceProvider);

    return songsAsync.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
      data: (songs) => ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            title: Text(song.title),
            onTap: () {
              // Convert SongModel → MediaItem, then load the queue
              final items = songs.map((s) => songToMediaItem(s)).toList();
              playback.loadQueue(items, index);

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PlayerView()),
              );
            },
          );
        },
      ),
    );
  }
}
