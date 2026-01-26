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
    // listen to player State
    _player.playerStateStream.listen((state) {
      playbackState.add(
        playbackState.value.copyWith(
          controls: [
            MediaControl.skipToPrevious,
            state.playing ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
          ],
          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },
          androidCompactActionIndices: const [0, 1, 2],
          playing: state.playing,
          processingState: _mapState(state.processingState),
          updatePosition: _player.position,
        ),
      );
    });

    // listen to queue
    _player.currentIndexStream.listen((index) {
      _currentIndex = index;

      if (index != null && index < _playlist.length) {
        mediaItem.add(_playlist[index]);
      }
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
  Future<void> skipToNext() async {
    await _player.seekToNext();
  }

  @override
  Future<void> skipToPrevious() async {
    await _player.seekToPrevious();
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
}
