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
  Stream<bool> get isPlaying => _playback.isPlayingStream;
  Stream<AudioServiceRepeatMode> get repeatMode => _playback.repeatModeStream;
  Stream<AudioServiceShuffleMode> get shuffleMode =>
      _playback.shuffleModeStream;
  Stream<bool> get canSkipNext => _playback.canSkipNextStream;
  Stream<bool> get canSkipPrev => _playback.canSkipPrevStream;

  Stream<SongModel?> get currentSong => _playback.currentSongStream.map(
    (item) => item == null
        ? null
        : state.queue.firstWhere(
            (song) => song.uri == item.id,
            orElse: () => state.queue.first,
          ),
  );

  PlayerBloc(this._playback) : super(PlayerState()) {
    on<TogglePlayPause>((event, emit) async {
      _playback.playbackState.value.playing
          ? await _playback.pause()
          : await _playback.play();
    });
    on<SkipNext>((event, emit) async => await _playback.skipToNext());
    on<SkipPrev>((event, emit) async => await _playback.skipToPrevious());
    on<Seek>((event, emit) async => await _playback.seek(event.position));
    on<LoadQueue>((event, emit) async {
      emit(state.copyWith(queue: event.playlist));
      await _playback.loadQueue(event.playlist, event.startIndex);
    });
    on<ToggleShuffle>((event, emit) async {
      final isShuffled =
          _playback.playbackState.value.shuffleMode ==
          AudioServiceShuffleMode.all;
      await _playback.setShuffleMode(
        isShuffled ? AudioServiceShuffleMode.none : AudioServiceShuffleMode.all,
      );
    });
    on<CycleRepeat>((event, emit) async {
      final current = _playback.playbackState.value.repeatMode;
      await _playback.setRepeatMode(switch (current) {
        AudioServiceRepeatMode.none => AudioServiceRepeatMode.all,
        AudioServiceRepeatMode.all => AudioServiceRepeatMode.one,
        _ => AudioServiceRepeatMode.none,
      });
    });
  }
}
