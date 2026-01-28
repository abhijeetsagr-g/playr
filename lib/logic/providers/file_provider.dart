import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/services/file_service.dart';

class FileProvider extends ChangeNotifier {
  final FileService _service;
  FileProvider(this._service);

  bool _isLoading = false;
  List<SongModel> _allSongs = [];
  List<AlbumModel> _albums = [];

  List<SongModel> _visibleSongs = [];
  int _songsPageSize = 20;

  final Map<int, Uint8List?> _albumArtCache = {};

  Future<void> init() async {
    if (_isLoading) return;
    _setLoading(true);

    _albums = await _service.getAlbums();
    _allSongs = await _service.fetchSongs();

    _updateVisibleSongs();
    _setLoading(false);
  }

  void _updateVisibleSongs() {
    _visibleSongs = _allSongs.take(_songsPageSize).toList();
    notifyListeners();
  }

  void loadMoreSongs() {
    if (_songsPageSize < _allSongs.length) {
      _songsPageSize += 20;
      _updateVisibleSongs();
    }
  }

  // Optimized artwork fetch
  Future<Uint8List?> getAlbumArtwork(int albumId) async {
    if (_albumArtCache.containsKey(albumId)) return _albumArtCache[albumId];

    final art = await _service.fetchArtwork(
      id: albumId,
      type: ArtworkType.ALBUM,
      size: 200,
    );

    _albumArtCache[albumId] = art;
    return art;
  }

  Future<List<SongModel>> fetchSongsByAlbum(int albumId) async {
    return await _service.fetchSongsByAlbum(albumId);
  }

  // Getters
  List<SongModel> get visibleSongs => _visibleSongs;
  List<AlbumModel> get albums => _albums;
  List<SongModel> get allSongs => _allSongs;
  bool get isLoading => _isLoading;

  void _setLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }
}
