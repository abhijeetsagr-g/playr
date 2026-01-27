import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:playr/ui/player/placeholder_widget.dart';
import 'package:provider/provider.dart';

class PlayerAlbumArt extends StatelessWidget {
  const PlayerAlbumArt({super.key});

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    return GestureDetector(
      onVerticalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;
        if (velocity > -300) {
          Navigator.pop(context);
        }
      },

      onHorizontalDragEnd: (details) {
        final velocity = details.primaryVelocity ?? 0;

        if (velocity < -300) {
          music.next();
        } else if (velocity > 300) {
          music.previous();
        }
      },

      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                (music.currentAlbumArtUri != null
                        ? Image.file(
                            File(music.currentAlbumArtUri!.toFilePath()),
                            fit: BoxFit.cover,
                          )
                        : const PlaceholderWidget())
                    .animate(key: ValueKey(music.currentPath ?? 'no-song'))
                    .fadeIn(duration: 300.ms)
                    .scale(
                      begin: const Offset(0.95, 0.95),
                      curve: Curves.easeOutCubic,
                    ),
          ),
        ),
      ),
    );
  }
}
