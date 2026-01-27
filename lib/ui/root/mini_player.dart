import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:provider/provider.dart';

class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key, required this.changePage});

  final VoidCallback changePage;

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    return GestureDetector(
      onTap: () => changePage(),

      child: Container(
        height: 75,
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          // color: MyThemes.bgColor,
          color: Colors.black.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withAlpha(20),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            // IconButton(
            //   icon: const Icon(
            //     Icons.keyboard_arrow_down_rounded,
            //     // color: MyThemes.activeIcon,
            //   ),
            //   onPressed: () {},
            // ),
            // Song Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    music.currentTitle ?? "Song Title",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    music.currentArtist ?? "Artist Name",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Controls
            IconButton(
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: () => music.previous(),
            ),
            IconButton(
              icon: Icon(
                music.isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                size: 32,
              ),
              onPressed: () => music.togglePlayAndPause(),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: () => music.next(),
            ),
          ],
        ),
      ),
    );
  }
}
