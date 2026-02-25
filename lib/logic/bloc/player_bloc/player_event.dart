import 'package:on_audio_query/on_audio_query.dart';

abstract class PlayerEvent {}

// Playback
class TogglePlayPause extends PlayerEvent {}

class SkipNext extends PlayerEvent {}

class SkipPrev extends PlayerEvent {}

class Seek extends PlayerEvent {
  final Duration pos;
  Seek({required this.pos});
}

class LoadQueue extends PlayerEvent {
  final List<SongModel> playlist;
  final int startIndex;
  LoadQueue({required this.playlist, required this.startIndex});
}

// Modes
class ToggleShuffle extends PlayerEvent {}

class CycleRepeat extends PlayerEvent {}
