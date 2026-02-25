import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/provider/audio_providers.dart';

class AlbumArt extends ConsumerWidget {
  const AlbumArt({super.key});

  Widget _placeholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFEEEEEE),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Icon(
        Icons.music_note_rounded,
        size: 80,
        color: Color(0xFFCCCCCC),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final songAsync = ref.watch(currentSongProvider);
    final size = MediaQuery.of(context).size.width - 64;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 40,
            offset: const Offset(0, 16),
            spreadRadius: -8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: songAsync.when(
          loading: () => _placeholder(size),
          error: (e, _) => _placeholder(size),
          data: (song) {
            final songId = song?.extras?['id'] as int?;
            if (songId == null) return _placeholder(size);

            return QueryArtworkWidget(
              id: songId,
              type: ArtworkType.AUDIO,
              artworkWidth: size,
              artworkHeight: size,
              artworkFit: BoxFit.cover,
              artworkBorder: BorderRadius.circular(24),
              nullArtworkWidget: _placeholder(size),
            );
          },
        ),
      ),
    );
  }
}
