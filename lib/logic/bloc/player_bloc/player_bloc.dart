import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playr/logic/bloc/player_bloc/player_event.dart';
import 'package:playr/logic/bloc/player_bloc/player_state.dart';
import 'package:playr/logic/services/playback_service.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlaybackService _playback;

  PlayerBloc(this._playback) : super(PlayerState()) {
    on<TogglePlayPause>((event, emit) async {
      if (state.isPlaying) {
        await _playback.pause();
      } else {
        await _playback.play();
      }
      emit(state.copyWith(isPlaying: !state.isPlaying));
    });

    on<SkipNext>((event, emit) async {
      await _playback.skipToNext();

      final mediaItem = _playback.mediaItem.value;
      if (mediaItem == null) {
        emit(state.copyWith(isPlaying: false));
        return;
      }

      final newSong = state.queue.firstWhere(
        (song) => song.uri == mediaItem.id,
        orElse: () => state.currentSong!,
      );

      emit(state.copyWith(currentSong: newSong));
    });

    on<SkipPrev>((event, emit) async {
      await _playback.skipToNext();

      final mediaItem = _playback.mediaItem.value;
      if (mediaItem == null) {
        emit(state.copyWith(isPlaying: false));
        return;
      }

      final newSong = state.queue.firstWhere(
        (song) => song.uri == mediaItem.id,
        orElse: () => state.currentSong!,
      );

      emit(state.copyWith(currentSong: newSong));
    });

    on<Seek>((event, emit) async {
      await _playback.seek(event.pos);

      emit(state);
    });

    on<LoadQueue>((event, emit) async {
      await _playback.loadQueue(event.playlist, event.startIndex);
      emit(
        state.copyWith(
          currentSong: event.playlist[event.startIndex],
          isPlaying: true,
          queue: event.playlist,
        ),
      );
    });

    on<ToggleShuffle>((event, emit) async {
      await _playback.setShuffleMode(
        state.isShuffle
            ? AudioServiceShuffleMode.none
            : AudioServiceShuffleMode.all,
      );

      emit(state.copyWith(isShuffle: !state.isShuffle));
    });

    on<CycleRepeat>((event, emit) async {
      late AudioServiceRepeatMode repeatMode;
      late RepeatMode newMode;
      switch (state.repeatMode) {
        case RepeatMode.all:
          repeatMode = AudioServiceRepeatMode.none;
          newMode = RepeatMode.none;
          break;
        case RepeatMode.none:
          repeatMode = AudioServiceRepeatMode.one;
          newMode = RepeatMode.one;
          break;
        case RepeatMode.one:
          repeatMode = AudioServiceRepeatMode.all;
          newMode = RepeatMode.all;
          break;
      }

      await _playback.setRepeatMode(repeatMode);

      emit(state.copyWith(repeatMode: newMode));
    });
  }
}
