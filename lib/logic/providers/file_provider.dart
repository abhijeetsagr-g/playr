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

  void init() async {
    _changeLoading(false);
    await _service.getPermission();
    _changeLoading(true);
  }

  Future<void> getMedia() async {
    _changeLoading(false);
    _allSongs = await _service.getMedia();
    _changeLoading(true);
  }

  // helpers
  void _changeLoading(bool isloading) {
    _isLoading = isloading;
    notifyListeners();
  }
}
