import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:playr/logic/provider/audio_providers.dart';
import 'package:playr/ui/player/widget/album_art.dart';

class PlayerView extends ConsumerWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSong = ref.watch(currentSongProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(currentSong.value?.album ?? "Unknown Album"),
      ),
      body: Column(children: [AlbumArt()]),
    );
  }
}
