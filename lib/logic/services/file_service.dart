import 'package:on_audio_query/on_audio_query.dart';
import 'dart:typed_data';

class FileService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  Future<bool> _ensurePermission() async {
    if (_hasPermission) return true;
    _hasPermission = await _audioQuery.checkAndRequest();
    return _hasPermission;
  }

  Future<List<SongModel>> fetchSongs({int? limit}) async {
    if (!await _ensurePermission()) return [];

    return await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      sortType: SongSortType.TITLE,
      ignoreCase: true,
    );
  }

  // get songs by album
  Future<List<SongModel>> fetchSongsByAlbum(int albumId) async {
    if (!await _ensurePermission()) return [];

    return await _audioQuery.queryAudiosFrom(
      AudiosFromType.ALBUM_ID,
      albumId,
      sortType: SongSortType.TITLE,
      // orderType: OrderType.,
    );
  }

  // get album details
  Future<List<AlbumModel>> getAlbums() async {
    if (!await _ensurePermission()) return [];
    return await _audioQuery.queryAlbums(
      sortType: AlbumSortType.ALBUM,
      orderType: OrderType.ASC_OR_SMALLER,
    );
  }

  Future<Uint8List?> fetchArtwork({
    required int id,
    required ArtworkType type,
    int size = 300,
  }) async {
    return await _audioQuery.queryArtwork(id, type, size: size);
  }

  // getters
  bool get hasPermission => _hasPermission;
}
