part of 'player_bloc.dart';

enum RepeatMode { none, one, all }

class PlayerState {
  final bool isPlaying;
  final bool isBuffering;
  final bool isCompleted;
  final bool isShuffle;
  final RepeatMode repeatMode;
  final SongModel? currentSong;
  final List<SongModel> queue;

  PlayerState({
    this.isPlaying = false,
    this.isBuffering = false,
    this.isCompleted = false,
    this.isShuffle = false,
    this.repeatMode = RepeatMode.none,
    this.currentSong,
    this.queue = const [],
  });

  PlayerState copyWith({
    bool? isPlaying,
    bool? isBuffering,
    bool? isCompleted,
    bool? isShuffle,
    RepeatMode? repeatMode,
    SongModel? currentSong,
    List<SongModel>? queue,
  }) {
    return PlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isBuffering: isBuffering ?? this.isBuffering,
      isCompleted: isCompleted ?? this.isCompleted,
      isShuffle: isShuffle ?? this.isShuffle,
      repeatMode: repeatMode ?? this.repeatMode,
      currentSong: currentSong ?? this.currentSong,
      queue: queue ?? this.queue,
    );
  }
}
