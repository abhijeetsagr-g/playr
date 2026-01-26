import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:playr/core/utils/artwork_utils.dart';

class Song {
  String path;
  String title;
  String artist;
  String albumName;
  Duration totalDur;
  Uint8List? albumCover;

  Song({
    required this.path,
    required this.title,
    required this.artist,
    required this.albumName,
    required this.totalDur,
    this.albumCover,
  });
}
