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

/// 🔒 Internal events (stream-driven)
class _PlaybackStateChanged extends PlayerEvent {
  final PlaybackState state;
  _PlaybackStateChanged(this.state);
}

class _MediaItemChanged extends PlayerEvent {
  final MediaItem mediaItem;
  _MediaItemChanged(this.mediaItem);
}
