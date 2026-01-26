import 'package:audio_service/audio_service.dart';
import 'package:playr/core/utils/artwork_utils.dart';
import 'package:playr/logic/model/song_model.dart';

abstract class SongMediaItemMapper {
  static final _artCache = <String, Uri?>{};

  static Future<MediaItem> map(Song song) async {
    Uri? artUri;

    if (_artCache.containsKey(song.path)) {
      artUri = _artCache[song.path];
    } else {
      artUri = await saveArtworkToFile(
        song.albumCover,
        song.path.hashCode.toString(),
      );
      _artCache[song.path] = artUri;
    }

    return MediaItem(
      id: song.path,
      title: song.title,
      artist: song.artist,
      album: song.albumName,
      duration: song.totalDur,
      artUri: artUri,
    );
  }
}
