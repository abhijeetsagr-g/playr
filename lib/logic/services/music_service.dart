import 'package:on_audio_query/on_audio_query.dart';

class MusicService {
  final OnAudioQuery _audioQuery = OnAudioQuery();

  // Request Permission
  Future<bool> _hasPermission() async => _audioQuery.permissionsRequest();

  // Get All Songs
  Future<List<SongModel>> getSongs({required SongSortType sort}) async {
    if (await _hasPermission() == false) return [];
    return _audioQuery.querySongs(
      sortType: sort,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
  }

  // Search Song by name
  Future<List<SongModel>> searchSongs(String query) async {
    final songs = await getSongs(sort: SongSortType.TITLE);
    return songs
        .where((song) => song.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // Get All Albums / Artists / Playlists
  Future<List<AlbumModel>> get getAlbums async => _audioQuery.queryAlbums();
  Future<List<ArtistModel>> get getArtists async => _audioQuery.queryArtists();
  Future<List<PlaylistModel>> get getPlaylists async =>
      _audioQuery.queryPlaylists();
  Future<List<GenreModel>> get getGenres async => _audioQuery.queryGenres();
}
