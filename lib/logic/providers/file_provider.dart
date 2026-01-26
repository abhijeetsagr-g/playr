import 'package:flutter/material.dart';
import 'package:playr/logic/model/song_model.dart';
import 'package:playr/logic/services/file_service.dart';

class FileProvider extends ChangeNotifier {
  final FileService _service;
  FileProvider(this._service);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Song> _allSongs = [];
  List<Song> get allSongs => _allSongs;

  Future<void> init() async {
    _changeLoading(true);
    await _service.getPermission();
    await getMedia();
    _changeLoading(false);
  }

  Future<void> getMedia() async {
    _changeLoading(false);
    _allSongs = await _service.getMedia();
    _changeLoading(true);
  }

  bool hasPermission() => _service.hasPermission;

  // helpers
  void _changeLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }
}
