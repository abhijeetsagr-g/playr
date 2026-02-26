part of 'player_bloc.dart';

abstract class PlayerEvent {}

class TogglePlayPause extends PlayerEvent {}

class SkipNext extends PlayerEvent {}

class SkipPrev extends PlayerEvent {}

class Seek extends PlayerEvent {
  final Duration position;
  Seek(this.position);
}

class LoadQueue extends PlayerEvent {
  final List<SongModel> playlist;
  final int startIndex;
  LoadQueue(this.playlist, this.startIndex);
}

class ToggleShuffle extends PlayerEvent {}

class CycleRepeat extends PlayerEvent {}

class SongChanged extends PlayerEvent {
  final SongModel song;
  SongChanged(this.song);
}

class PlaybackStateChanged extends PlayerEvent {
  final bool isPlaying;
  final AudioProcessingState processingState;
  PlaybackStateChanged(this.isPlaying, this.processingState);
}
