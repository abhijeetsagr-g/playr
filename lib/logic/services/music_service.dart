import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MusicService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();
  List<MediaItem> _playlist = [];
  int _currentIndex = -1;

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

  // playlist management
  Future<void> setPlaylist(
    List<MediaItem> items,
    int startIndex, {
    bool play = true,
  }) async {
    _playlist = items;
    _currentIndex = startIndex;

    // Convert your items to AudioSources
    final sources = items
        .map(
          (item) => AudioSource.uri(
            Uri.parse(item.id),
            tag: item, // Use tag to keep track of metadata
          ),
        )
        .toList();

    await _player.setAudioSources(
      sources,
      initialIndex: startIndex,
      initialPosition: Duration.zero,
    );

    // Update your streams/UI
    queue.add(_playlist);
    mediaItem.add(_playlist[_currentIndex]);

    if (!play) {
      await _player.play();
    }
  }

  Future<void> addSongToQueue(MediaItem item) async {
    final source = AudioSource.uri(Uri.parse(item.id), tag: item);
    final currentPlayingIndex = _player.currentIndex;

    if (currentPlayingIndex != null) {
      await _player.insertAudioSource(currentPlayingIndex + 1, source);

      _playlist.insert(currentPlayingIndex + 1, item);
      queue.add(List.from(_playlist));
    } else {
      await setPlaylist([item], 0, play: false);
    }
  }

  // set loop
  Future<void> setLoopOne(bool enabled) async {
    await _player.setLoopMode(enabled ? LoopMode.one : LoopMode.off);
  }

  MediaItem? get nextMediaItem {
    final state = _player.sequenceState;
    final int? nextIndex = _player.nextIndex;

    if (nextIndex != null && nextIndex < state.effectiveSequence.length) {
      return state.effectiveSequence[nextIndex].tag as MediaItem;
    }
    return null;
  }

  // set shuffle
  Future<void> setShuffle(bool enabled) async {
    await _player.setShuffleModeEnabled(enabled);

    if (enabled) {
      await _player.shuffle();
    }
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
  bool get isShuffleEnabled => _player.shuffleModeEnabled;
  Stream<Duration> get positionStream => _player.positionStream;
  Stream<Duration?> get durationStream => _player.durationStream;
}
