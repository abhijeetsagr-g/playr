import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:playr/ui/player/control_input.dart';
import 'package:playr/ui/player/player_album_art.dart';
import 'package:playr/ui/player/seek_slider.dart';
import 'package:provider/provider.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  Widget _body(MusicProvider music) => Center(
    child: Column(
      children: [
        PlayerAlbumArt(),
        Text(
              music.currentTitle ?? "Song Name",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate(key: ValueKey(music.currentTitle ?? "No Song Title"))
            .fadeIn(duration: 250.ms)
            .slideY(begin: 0.2),

        const SizedBox(height: 6),

        Text(
              music.currentArtist ?? "Artist Name",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            )
            .animate(key: ValueKey(music.currentArtist))
            .fadeIn(duration: 250.ms)
            .slideY(begin: 0.2),

        const SizedBox(height: 30),
        const SeekSlider(),

        SizedBox(height: 24),

        const ControlInput(),

        SizedBox(height: 24),
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
        elevation: 0,
        leading: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.keyboard_arrow_down),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _body(music),
    );
  }
}
