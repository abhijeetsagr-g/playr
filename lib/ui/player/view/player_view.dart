import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';
import 'package:playr/ui/player/widget/album_art.dart';
import 'package:playr/ui/player/widget/control_buttons.dart';
import 'package:playr/ui/player/widget/next_song_label.dart';
import 'package:playr/ui/player/widget/seek_bar.dart';
import 'package:playr/ui/player/widget/song_info.dart';

class PlayerView extends StatelessWidget {
  const PlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerBloc, PlayerState, SongModel?>(
      selector: (state) => state.currentSong,
      builder: (context, song) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_arrow_down),
          ),
          centerTitle: true,
          title: Text(
            song?.album ?? "Unknown Album",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              AlbumArt(song: song),
              SizedBox(height: 20),
              SongInfo(
                title: song?.title ?? "Unknown title",
                artist: song?.artist ?? "Unknown Artist",
              ),
              SizedBox(height: 20),
              SeekBar(),
              ControlButtons(),
              // NextSongLabel(),
            ],
          ),
        ),
        bottomNavigationBar: NextSongLabel(),
      ),
    );
  }
}
