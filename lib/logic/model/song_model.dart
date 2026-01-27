import 'dart:typed_data';

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
