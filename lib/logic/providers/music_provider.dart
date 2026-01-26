import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playr/core/utils/song_media_item_wrapper.dart';
import 'package:playr/logic/model/song_model.dart';
import 'package:playr/logic/services/music_service.dart';

class MusicProvider extends ChangeNotifier {
  final MusicService _service;
  late final StreamSubscription _stateSub;

  MusicProvider(this._service) {
    _stateSub = _service.playbackState.listen((_) {
      notifyListeners();
    });
  }

  // Commands
  Future<void> playPlaylist(List<Song> songs, int startIndex) async {
    final items = <MediaItem>[];

    for (final song in songs) {
      final item = await SongMediaItemMapper.map(song);
      items.add(item);
    }

    await _service.setPlaylist(items, startIndex);
    await _service.play();
  }

  Future<void> play() => _service.play();
  Future<void> pause() => _service.pause();
  Future<void> next() => _service.skipToNext();
  Future<void> previous() => _service.skipToPrevious();

  // Derived state (read-only)
  bool get isPlaying => _service.playbackState.value.playing;
  String? get currentTitle => _service.mediaItem.value?.title;
  String? get currentPath => _service.mediaItem.value?.id;
  int? get currentIndex => _service.currentIndex;

  @override
  void dispose() {
    _stateSub.cancel();
    super.dispose();
  }
}
