import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/bloc/media_bloc/media_state.dart';
import 'package:playr/logic/services/music_service.dart';

class MediaCubit extends Cubit<MediaState> {
  final MusicService service = MusicService();

  MediaCubit() : super(MediaState());

  Future<void> loadSongs() async {
    emit(state.copyWith(status: MediaStatus.loading));

    try {
      final songs = await service.getSongs(sort: SongSortType.TITLE);

      emit(state.copyWith(status: MediaStatus.loaded, songs: songs));
    } catch (e) {
      emit(state.copyWith(status: MediaStatus.error, error: e.toString()));
    }
  }

  Future<void> searchSongs(String query) async {
    emit(state.copyWith(status: MediaStatus.loading));

    final results = await service.searchSongs(query);

    emit(state.copyWith(status: MediaStatus.loaded, songs: results));
  }
}
