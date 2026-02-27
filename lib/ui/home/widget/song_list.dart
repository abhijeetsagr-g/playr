import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/core/utils/format_dur.dart';
import 'package:playr/logic/bloc/media_bloc/media_cubit.dart';
import 'package:playr/logic/bloc/media_bloc/media_state.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';
import 'package:playr/ui/player/widget/album_art.dart';

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
    final bloc = context.read<PlayerBloc>();
    return StreamBuilder<bool>(
      stream: bloc.currentSong
          .map((current) => current?.id == song.id)
          .distinct(),
      initialData: false,
      builder: (context, snapshot) {
        final isActive = snapshot.data ?? false;
        return ListTile(
          selected: isActive,
          textColor: isActive ? Colors.purple : null,
          leading: AlbumArt(song: song),
          trailing: Text(formatDur(song.duration ?? 0)),
          title: Text(song.title),
          subtitle: Text(song.artist ?? "Unknown"),
          onTap: () => bloc.add(LoadQueue(playlist, index)),
        );
      },
    );
  }
}
