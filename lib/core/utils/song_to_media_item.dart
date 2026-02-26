import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';

MediaItem songToMediaItem(SongModel song, {Uri? artUri}) {
  return MediaItem(
    id: song.uri ?? '',
    title: song.title,
    artist: song.artist,
    album: song.album,
    duration: Duration(milliseconds: song.duration ?? 0),
    artUri: artUri,
    extras: {'id': song.id},
  );
}
