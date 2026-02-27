part of 'player_bloc.dart';

enum RepeatMode { none, one, all }

class PlayerState {
  final List<SongModel> queue;

  PlayerState({this.queue = const []});

  PlayerState copyWith({List<SongModel>? queue}) {
    return PlayerState(queue: queue ?? this.queue);
  }
}
