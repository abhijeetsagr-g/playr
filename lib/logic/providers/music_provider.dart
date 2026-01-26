import 'package:flutter/material.dart';
import 'package:playr/logic/model/song_model.dart';
import 'package:playr/logic/services/music_service.dart';

class MusicProvider extends ChangeNotifier {
  final MusicService _service;

  MusicProvider(this._service);

  bool get isPlaying => _service.playbackState.value.playing;

  String? get currentTitle => _service.mediaItem.value?.title;

  // Commands
  Future<void> playSong(Song song) async {
    await _service.playSong(song.path, song.title);
    notifyListeners();
  }

  Future<void> play() async {
    await _service.play();
    notifyListeners();
  }

  Future<void> pause() async {
    await _service.pause();
    notifyListeners();
  }
}
