import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/core/utils/format_dur.dart';
import 'package:playr/core/widget/marquee_text.dart';
import 'package:playr/logic/bloc/media_bloc/media_cubit.dart';
import 'package:playr/logic/bloc/media_bloc/media_state.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';
import 'package:playr/ui/player/view/player_view.dart';

class SongList extends StatelessWidget {
  const SongList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MediaCubit, MediaState>(
      builder: (context, state) {
        if (state.status == MediaStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == MediaStatus.error) {
          return Center(child: Text(state.error ?? "Something went wrong"));
        }

        final songs = state.songs;

        return ListView.builder(
          itemCount: songs.length,
          padding: EdgeInsets.only(bottom: 100),
          itemBuilder: (context, index) {
            final song = songs[index];

            return _SongTile(song: song, playlist: songs, index: index);
          },
        );
      },
    );
  }
}

class _SongTile extends StatelessWidget {
  final SongModel song;
  final List<SongModel> playlist;
  final int index;

  const _SongTile({
    required this.song,
    required this.playlist,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PlayerBloc, PlayerState, bool>(
      selector: (state) => state.currentSong?.uri == song.uri,
      builder: (context, isActive) {
        return ListTile(
          selected: isActive,
          textColor: isActive ? Colors.purple : null,
          leading: QueryArtworkWidget(
            id: song.id,
            type: ArtworkType.AUDIO,
            nullArtworkWidget: const Icon(Icons.music_note),
          ),
          trailing: Text(formatDur(song.duration ?? 0)),
          title: MarqueeText(text: song.title, style: TextStyle()),
          subtitle: Text(song.artist ?? "Unknown"),
          onTap: () {
            context.read<PlayerBloc>().add(LoadQueue(playlist, index));
          },
        );
      },
    );
  }
}
