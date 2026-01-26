import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class MusicService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer _player = AudioPlayer();

  MusicService() {
    _init();
  }

  void _init() {
    // Listen to player state
    _player.playerStateStream.listen((state) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: state.playing,
          processingState: _mapState(state.processingState),
        ),
      );
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

  Future<void> playSong(String path, String title) async {
    final mediaItem = MediaItem(id: path, title: title);
    this.mediaItem.add(mediaItem);
    await _player.setAudioSource(AudioSource.uri(Uri.parse(path)));
    await play();
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
}
