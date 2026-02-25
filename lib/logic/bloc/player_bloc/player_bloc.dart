import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/services/playback_service.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  final PlaybackService _playback;

  late final StreamSubscription<PlaybackState> _playbackSub;
  late final StreamSubscription<MediaItem?> _mediaItemSub;

  PlayerBloc(this._playback) : super(PlayerState()) {
    // Listen to playback state (play/pause/buffering/completed)
    _playbackSub = _playback.playbackState.listen((playbackState) {
      add(_PlaybackStateChanged(playbackState));
    });

    // Listen to current playing media
    _mediaItemSub = _playback.mediaItem.listen((mediaItem) {
      if (mediaItem != null) {
        add(_MediaItemChanged(mediaItem));
      }
    });

    /// ---------------- STATE LISTENERS ----------------

    on<_PlaybackStateChanged>((event, emit) {
      final processingState = event.state.processingState;

      emit(
        state.copyWith(
          isPlaying: event.state.playing,
          isBuffering: processingState == AudioProcessingState.buffering,
          isCompleted: processingState == AudioProcessingState.completed,
        ),
      );
    });

    on<_MediaItemChanged>((event, emit) {
      final song = state.queue
          .where((s) => s.uri == event.mediaItem.id)
          .cast<SongModel?>()
          .firstOrNull;

      if (song != null) {
        emit(state.copyWith(currentSong: song));
      }
    });

    // Commands

    on<TogglePlayPause>((event, emit) async {
      if (state.isPlaying) {
        await _playback.pause();
      } else {
        await _playback.play();
      }
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
      await _playback.loadQueue(event.playlist, event.startIndex);

      emit(state.copyWith(queue: event.playlist));
      // currentSong & isPlaying handled by streams
    });

    on<ToggleShuffle>((event, emit) async {
      final newShuffle = !state.isShuffle;

      await _playback.setShuffleMode(
        newShuffle ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      );

      emit(state.copyWith(isShuffle: newShuffle));
    });

    on<CycleRepeat>((event, emit) async {
      late AudioServiceRepeatMode audioRepeat;
      late RepeatMode newMode;

      switch (state.repeatMode) {
        case RepeatMode.none:
          audioRepeat = AudioServiceRepeatMode.one;
          newMode = RepeatMode.one;
          break;
        case RepeatMode.one:
          audioRepeat = AudioServiceRepeatMode.all;
          newMode = RepeatMode.all;
          break;
        case RepeatMode.all:
          audioRepeat = AudioServiceRepeatMode.none;
          newMode = RepeatMode.none;
          break;
      }

      await _playback.setRepeatMode(audioRepeat);
      emit(state.copyWith(repeatMode: newMode));
    });
  }

  @override
  Future<void> close() {
    _playbackSub.cancel();
    _mediaItemSub.cancel();
    return super.close();
  }
}
