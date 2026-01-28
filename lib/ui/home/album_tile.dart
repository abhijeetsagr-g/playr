import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:provider/provider.dart';

class AlbumTile extends StatelessWidget {
  const AlbumTile({super.key, required this.album});
  final AlbumModel album;

  Widget albumPlaceholder() {
    return Container(
      color: Colors.grey.shade900,
      alignment: Alignment.center,
      child: const Icon(
        Icons.music_note_rounded,
        size: 30, // Smaller icon for 3-column layout
        color: Colors.white54,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fileProvider = context.read<FileProvider>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1 / 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              10,
            ), // Slightly smaller radius for smaller tiles
            child: FutureBuilder<Uint8List?>(
              future: fileProvider.getAlbumArtwork(album.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done &&
                    snapshot.hasData &&
                    snapshot.data != null) {
                  return Image.memory(snapshot.data!, fit: BoxFit.cover);
                }
                return albumPlaceholder();
              },
            ),
          ),
        ),
        const SizedBox(height: 6), // Tightened spacing
        Text(
          album.album,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13, // Smaller font for 3-column grid
          ),
        ),
        Text(
          album.artist ?? 'Unknown Artist',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11, // Smaller font
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
