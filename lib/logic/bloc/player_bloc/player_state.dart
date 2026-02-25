import 'package:on_audio_query/on_audio_query.dart';

enum RepeatMode { none, one, all }

class PlayerState {
  final SongModel? currentSong;
  final bool isPlaying;
  final bool isShuffle;
  final RepeatMode repeatMode;
  final List<SongModel> queue;

  PlayerState({
    this.currentSong,
    this.isPlaying = false,
    this.isShuffle = false,
    this.repeatMode = RepeatMode.none,
    this.queue = const [],
  });

  PlayerState copyWith({
    SongModel? currentSong,
    bool? isPlaying,
    bool? isShuffle,
    RepeatMode? repeatMode,
    List<SongModel>? queue,
  }) {
    return PlayerState(
      currentSong: currentSong ?? this.currentSong,
      isPlaying: isPlaying ?? this.isPlaying,
      isShuffle: isShuffle ?? this.isShuffle,
      repeatMode: repeatMode ?? this.repeatMode,
      queue: queue ?? this.queue,
    );
  }
}
