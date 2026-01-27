import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playr/core/utils/song_media_item_wrapper.dart';
import 'package:playr/logic/model/song_model.dart';
import 'package:playr/logic/services/music_service.dart';

class MusicProvider extends ChangeNotifier {
  final MusicService _service;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  late final StreamSubscription _stateSub;
  late final StreamSubscription _positionSub;
  late final StreamSubscription _durationSub;

  MusicProvider(this._service) {
    _stateSub = _service.playbackState.listen((_) {
      notifyListeners();
    });

    _positionSub = _service.positionStream.listen((pos) {
      if (pos != _position) {
        _position = pos;
        notifyListeners();
      }
    });

    _durationSub = _service.durationStream.listen((dur) {
      final newDuration = dur ?? Duration.zero;
      if (newDuration != _duration) {
        _duration = newDuration;
        notifyListeners();
      }
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

  Future<void> togglePlayAndPause() async {
    final state = _service.playbackState.value;

    if (state.playing) {
      await _service.pause();
    } else if (state.processingState != AudioProcessingState.loading &&
        state.processingState != AudioProcessingState.buffering) {
      await _service.play();
    }
  }

  Future<void> next() => _service.skipToNext();
  Future<void> previous() => _service.skipToPrevious();

  void seek(Duration position) => _service.seek(position);
  Stream<Duration> get positionStream => _service.positionStream;
  Stream<Duration?> get durationStream => _service.durationStream;

  // Derived state (read-only)
  bool get isPlaying => _service.playbackState.value.playing;
  int? get currentIndex => _service.currentIndex;
  String? get currentTitle => _service.mediaItem.value?.title;
  String? get currentPath => _service.mediaItem.value?.id;
  String? get currentArtist => _service.mediaItem.value?.artist;
  Uri? get currentAlbumArtUri => _service.mediaItem.value?.artUri;

  Duration get position => _position;
  Duration get duration => _duration;

  @override
  void dispose() {
    _stateSub.cancel();
    _positionSub.cancel();
    _durationSub.cancel();
    super.dispose();
  }
}
