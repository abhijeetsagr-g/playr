import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:provider/provider.dart';

class SongTile extends StatelessWidget {
  const SongTile({super.key, required this.song, this.onTap});

  final SongModel song;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.read<FileProvider>();

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 50,
          height: 50,
          child: FutureBuilder<Uint8List?>(
            // Fetching artwork based on track ID
            future: fileProvider.getAlbumArtwork(song.albumId ?? 0),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData &&
                  snapshot.data != null) {
                return Image.memory(snapshot.data!, fit: BoxFit.cover);
              }
              return Container(
                color: Colors.grey.shade900,
                child: const Icon(Icons.music_note, color: Colors.white54),
              );
            },
          ),
        ),
      ),
      title: Text(
        song.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
      ),
      subtitle: Text(
        song.artist ?? "Unknown Artist",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.more_vert_rounded, size: 20),
        onPressed: () {
          // Handle more options (Add to playlist, etc.)
        },
      ),
    );
  }
}
