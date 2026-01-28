import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:playr/core/common/marquee_text.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:playr/ui/player/control_input.dart';
import 'package:playr/ui/player/player_album_art.dart';
import 'package:playr/ui/player/seek_slider.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  Widget _body(MusicProvider music, BuildContext context) => Center(
    child: Column(
      children: [
        PlayerAlbumArt(),
        SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.access_time_rounded, size: 24),
              ),

              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MarqueeText(
                        text: music.currentTitle ?? "Song Name",
                        maxWidth: MediaQuery.of(context).size.width * 0.6,
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                            music.currentArtist ?? "Artist Name",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          )
                          .animate(key: ValueKey(music.currentArtist))
                          .fadeIn(duration: 250.ms)
                          .slideY(begin: 0.2),
                    ],
                  ),
                ),
              ),

              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_border, size: 24),
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),
        const SeekSlider(),
        const SizedBox(height: 30),
        const ControlInput(),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          music.currentAlbum ?? "Play Soon",
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ),
      body: _body(music, context),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          child: Row(
            children: [
              Icon(Icons.playlist_play_outlined, color: Colors.grey, size: 18),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NEXT SONG",
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  Text(
                    music.isShuffleEnabled
                        ? "Shuffle means Suprises"
                        : music.isLoopOnce
                        ? music.currentTitle ?? "No Song Yet"
                        : music.nextTitle ?? "This was the last song",
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
