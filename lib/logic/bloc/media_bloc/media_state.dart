import 'package:on_audio_query/on_audio_query.dart';

enum MediaStatus { initial, loading, loaded, error }

class MediaState {
  final MediaStatus status;
  final List<SongModel> songs;
  final String? error;

  MediaState({
    this.status = MediaStatus.initial,
    this.songs = const [],
    this.error,
  });

  MediaState copyWith({
    MediaStatus? status,
    List<SongModel>? songs,
    String? error,
  }) {
    return MediaState(
      status: status ?? this.status,
      songs: songs ?? this.songs,
      error: error ?? this.error,
    );
  }
}
