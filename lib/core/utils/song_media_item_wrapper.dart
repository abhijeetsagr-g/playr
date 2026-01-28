import 'dart:collection';
import 'package:audio_service/audio_service.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/core/utils/artwork_utils.dart';

abstract class SongMediaItemMapper {
  static final Map<int, Uri?> _artCache = HashMap();

  static Future<MediaItem> songModelToMediaItem(SongModel song) async {
    Uri? artUri;

    final albumId = song.albumId;

    if (albumId != null && _artCache.containsKey(albumId)) {
      artUri = _artCache[albumId];
    } else if (albumId != null) {
      // fetch raw artwork bytes
      final bytes = await OnAudioQuery().queryArtwork(
        albumId,
        ArtworkType.ALBUM,
        size: 300,
      );

      if (bytes != null) {
        artUri = await saveArtworkToFile(bytes, albumId.toString());
      }

      _artCache[albumId] = artUri;
    }

    return MediaItem(
      id: song.uri!, // playable
      title: song.title,
      album: song.album,
      artist: song.artist,
      duration: Duration(milliseconds: song.duration ?? 0),
      artUri: artUri,
      extras: {'albumId': song.albumId, 'songId': song.id},
    );
  }
}
