import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/services/playback_service.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlaybackService _playback;

  Stream<Duration> get position => _playback.positionStream;
  Stream<Duration?> get duration => _playback.durationStream;

  PlayerBloc(this._playback) : super(PlayerState()) {
    _playback.playbackState.listen((pbState) {
      add(PlaybackStateChanged(pbState.playing, pbState.processingState));
    });

    _playback.mediaItem.listen((mediaItem) {
      if (mediaItem == null) return;

      if (state.queue.isEmpty) return;

      final newSong = state.queue.firstWhere(
        (song) => song.uri == mediaItem.id,
        orElse: () => state.currentSong ?? state.queue.first,
      );
      add(SongChanged(newSong));
    });

    on<SongChanged>((event, emit) {
      emit(state.copyWith(currentSong: event.song, isPlaying: true));
    });

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
    });

    on<SkipPrev>((event, emit) async {
      await _playback.skipToPrevious();
    });

    on<Seek>((event, emit) async {
      await _playback.seek(event.position);
    });

    on<LoadQueue>((event, emit) async {
      emit(
        state.copyWith(
          currentSong: event.playlist[event.startIndex],
          isPlaying: true,
          queue: event.playlist,
        ),
      );
      await _playback.loadQueue(event.playlist, event.startIndex);
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
        case RepeatMode.one:
          repeatMode = AudioServiceRepeatMode.none;
          newMode = RepeatMode.none;
          break;
        case RepeatMode.all:
          repeatMode = AudioServiceRepeatMode.one;
          newMode = RepeatMode.one;
          break;
        case RepeatMode.none:
          repeatMode = AudioServiceRepeatMode.all;
          newMode = RepeatMode.all;
          break;
      }

      await _playback.setRepeatMode(repeatMode);

      emit(state.copyWith(repeatMode: newMode));
    });

    on<PlaybackStateChanged>((event, emit) {
      if (event.processingState == AudioProcessingState.buffering ||
          event.processingState == AudioProcessingState.loading) {
        return;
      }

      emit(state.copyWith(isBuffering: false, isPlaying: event.isPlaying));
    });
  }
}
