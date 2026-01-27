import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MusicService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  final List<MediaItem> _playlist = [];
  int? _currentIndex;

  MusicService() {
    _init();
  }

  void _init() {
    // Set an explicit initial state
    playbackState.add(
      PlaybackState(
        controls: [],
        systemActions: {
          MediaAction.seek,
          MediaAction.playPause,
          MediaAction.skipToNext,
          MediaAction.skipToPrevious,
        },
        processingState: AudioProcessingState.idle,
        playing: false,
      ),
    );

    // Combine player state logic
    _player.playerStateStream.listen((state) {
      final playing = state.playing;
      final processingState = _mapState(state.processingState);

      playbackState.add(
        playbackState.value.copyWith(
          playing: playing,
          processingState: processingState,
          // Update controls dynamically based on state
          controls: [
            MediaControl.skipToPrevious,
            if (playing) MediaControl.pause else MediaControl.play,
            MediaControl.skipToNext,
          ],
        ),
      );
    });

    // Track Media Item changes safely
    _player.currentIndexStream.listen((index) {
      if (index != null && index < _playlist.length) {
        _currentIndex = index;
        mediaItem.add(_playlist[index]);
      }
    });

    // Position tracking (consider adding a throttle if UI performance dips)
    _player.positionStream.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });
  }

  // basic controls
  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> pause() async {
    await _player.pause();
  }

  @override
  Future<void> stop() async {
    await _player.stop();
    await _player.dispose();
    playbackState.add(
      playbackState.value.copyWith(
        playing: false,
        processingState: AudioProcessingState.idle,
      ),
    );
    return super.stop();
  }

  @override
  Future<void> skipToNext() async {
    await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    if (_player.position >= Duration(seconds: 3)) {
      seek(Duration.zero);
      return;
    }

    await _player.seekToPrevious();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  Future<void> setPlaylist(List<MediaItem> items, int startIndex) async {
    _currentIndex = startIndex;
    _playlist
      ..clear()
      ..addAll(items);

    // Build audio source list
    final sources = items
        .map((item) => AudioSource.uri(Uri.parse(item.id)))
        .toList();

    await _player.setAudioSources(sources, initialIndex: startIndex);

    // Update queue and mediaItem streams
    queue.add(List.unmodifiable(_playlist));
    mediaItem.add(_playlist[startIndex]);
  }

  // helper
  AudioProcessingState _mapState(ProcessingState state) {
    switch (state) {
      case ProcessingState.loading:
        return AudioProcessingState.loading;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        return AudioProcessingState.idle;
    }
  }

  // getter
  int? get currentIndex => _currentIndex;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
}
