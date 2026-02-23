import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class PlaybackService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  PlaybackService() {
    _init();
  }

  void _init() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) skipToNext();
    });
  }

  // Converts just_audio's internal state into audio_service's PlaybackState
  PlaybackState _transformEvent(PlaybackEvent event) {
    return PlaybackState(
      // Which buttons to show on the notification / lock screen
      controls: [
        MediaControl.skipToPrevious,
        if (_player.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],

      // Which actions are supported (for Android media session)
      systemActions: {
        MediaAction.setRepeatMode,
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
        MediaAction.setShuffleMode,
      },

      // Mapping just_audio ProcessingState → audio_service AudioProcessingState
      processingState: switch (_player.processingState) {
        ProcessingState.idle => AudioProcessingState.idle,
        ProcessingState.loading => AudioProcessingState.loading,
        ProcessingState.buffering => AudioProcessingState.buffering,
        ProcessingState.ready => AudioProcessingState.ready,
        ProcessingState.completed => AudioProcessingState.completed,
      },
      playing: _player.playing,
      updatePosition: _player.position,
      bufferedPosition: _player.bufferedPosition,
      speed: _player.speed,
      queueIndex: event.currentIndex,
    );
  }

  // Skip to Queue Index
  @override
  Future<void> skipToQueueItem(int index) async {
    final q = queue.value;
    if (index < 0 || index >= q.length) return;

    // Load and play the song at the given index
    await playSong(q[index]);

    // Update queue index in playback state
    playbackState.add(playbackState.value.copyWith(queueIndex: index));
  }

  // Play a Song
  Future<void> playSong(MediaItem song) async {
    mediaItem.add(song);
    await _player.setAudioSource(
      AudioSource.uri(Uri.parse(song.id)), // item.id = file URI
    );

    await play();
  }

  // Seek
  @override
  Future<void> seek(Duration position) => _player.seek(position);

  // Play Next
  @override
  Future<void> skipToNext() async {
    final q = queue.value;
    final current = playbackState.value.queueIndex ?? 0;
    final nextIndex = current + 1;

    if (nextIndex < q.length) {
      await skipToQueueItem(nextIndex);
    } else {
      await stop();
    }
  }

  // Play Previous
  @override
  Future<void> skipToPrevious() async {
    final position = _player.position;

    // reset if less than 3 sec
    if (position.inSeconds > 3) {
      await seek(Duration.zero);
    } else {
      final current = playbackState.value.queueIndex ?? 0;
      if (current > 0) await skipToQueueItem(current - 1);
    }
  }

  // set shuffle
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;
    await _player.setShuffleModeEnabled(enabled);

    // Change State with Shuffle On
    playbackState.add(playbackState.value.copyWith(shuffleMode: shuffleMode));
  }

  // set Repeat
  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    await _player.setLoopMode(switch (repeatMode) {
      AudioServiceRepeatMode.one => LoopMode.one,
      AudioServiceRepeatMode.all => LoopMode.all,
      _ => LoopMode.off,
    });

    playbackState.add(playbackState.value.copyWith(repeatMode: repeatMode));
  }

  // main controls
  @override
  Future<void> play() async => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }

  // getters
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
  bool get isPlaying => _player.playing;

  // dispose
  @override
  Future<void> onTaskRemoved() async {
    await stop();
    await _player.dispose();
  }
}
