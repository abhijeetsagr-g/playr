import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/core/utils/song_to_media_item.dart';

class PlaybackService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  bool _isLoading = false;

  PlaybackService() {
    _init();
  }

  void _init() {
    _player.playbackEventStream.map(_transformEvent).pipe(playbackState);

    // updates song through natural completion
    _player.currentIndexStream.listen((index) {
      if (_isLoading) return;
      if (index == null) return;
      final q = queue.value;
      if (q.isEmpty || index >= q.length) return;
      mediaItem.add(q[index]);
    });
  }

  // Converts just_audio's internal state into audio_service's AudioProcessing State
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
      shuffleMode: _player.shuffleModeEnabled
          ? AudioServiceShuffleMode.all
          : AudioServiceShuffleMode.none,
      repeatMode: switch (_player.loopMode) {
        LoopMode.one => AudioServiceRepeatMode.one,
        LoopMode.all => AudioServiceRepeatMode.all,
        _ => AudioServiceRepeatMode.none,
      },
    );
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
    if (position.inSeconds < 3) {
      final current = playbackState.value.queueIndex ?? 0;
      if (current > 0) await skipToQueueItem(current - 1);
    } else {
      await seek(Duration.zero);
    }
  }

  // set shuffle
  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final enabled = shuffleMode == AudioServiceShuffleMode.all;
    await _player.setShuffleModeEnabled(enabled);
  }

  // set Repeat
  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) async {
    await _player.setLoopMode(switch (repeatMode) {
      AudioServiceRepeatMode.one => LoopMode.one,
      AudioServiceRepeatMode.all => LoopMode.all,
      _ => LoopMode.off,
    });
  }

  Future<void> loadQueue(List<SongModel> items, int startIndex) async {
    final mediaItems = items.map((e) => songToMediaItem(e)).toList();

    _isLoading = true;

    queue.add(mediaItems);
    mediaItem.add(mediaItems[startIndex]);

    await _player.setAudioSources(
      mediaItems.map((item) => AudioSource.uri(Uri.parse(item.id))).toList(),
      initialIndex: startIndex,
      initialPosition: Duration.zero,
    );

    _isLoading = false;

    await _player.play();
  }

  Future<void> addToQueue(MediaItem item) async {
    await _player.addAudioSource(AudioSource.uri(Uri.parse(item.id)));
    queue.add([...queue.value, item]);
  }

  @override
  Future<void> skipToQueueItem(int index) async {
    await _player.seek(Duration.zero, index: index);
    await _player.play();
  }

  // Remove by index
  Future<void> removeFromQueue(int index) async {
    await _player.removeAudioSourceAt(index);
    final updated = [...queue.value]..removeAt(index);
    queue.add(updated);
  }

  // main controls
  @override
  Future<void> play() async => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
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
