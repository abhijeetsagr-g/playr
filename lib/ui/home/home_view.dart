import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:playr/core/common/album_art.dart';
import 'package:playr/core/common/marquee_text.dart';
import 'package:playr/core/utils/format_dur.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/logic/providers/music_provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // ⛔ DO NOT watch the whole provider
    final currentPath = context.select<MusicProvider, String?>(
      (m) => m.currentPath,
    );

    return Consumer<FileProvider>(
      builder: (context, fileProvider, _) {
        final songs = fileProvider.allSongs;

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
          itemCount: songs.length,
          itemExtent: 72, // 🔥 huge perf win
          itemBuilder: (context, index) {
            final song = songs[index];
            final isActive = song.path == currentPath;

            return ListTile(
              key: ValueKey(song.path),
              contentPadding: const EdgeInsets.symmetric(horizontal: 8),

              onTap: () {
                context.read<MusicProvider>().playPlaylist(songs, index);
              },

              onLongPress: () {
                context.read<MusicProvider>().addToQueue(song);
              },

              leading: AlbumArt(
                size: const Size(44, 44),
                artwork: song.albumCover,
              ),

              title: isActive
                  ? MarqueeText(
                      song.title,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.start,
                    )
                  : Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),

              subtitle: Text(
                song.artist,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(60),
                ),
              ),

              trailing: Text(
                formatDur(song.totalDur),
                style: theme.textTheme.bodySmall!.copyWith(
                  color: theme.colorScheme.onSurface.withAlpha(50),
                ),
              ),

              tileColor: isActive
                  ? theme.colorScheme.primary.withAlpha(8)
                  : null,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            );
          },
        );
      },
    );
  }
}
