import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/logic/model/song_model.dart';
import 'dart:typed_data';

class FileService {
  final OnAudioQuery _audioQuery = OnAudioQuery();
  bool _hasPermission = false;

  Future<void> getPermission() async {
    _hasPermission = await _audioQuery.checkAndRequest();
  }

  // Get a List of Songs, use it on Provider
  Future<List<Song>> getMedia() async {
    if (!_hasPermission) {
      await getPermission();
      if (!_hasPermission) {
        return [];
      }
    }

    List<SongModel> audioList = await _audioQuery.querySongs();
    List<Song> songs = [];

    for (var audio in audioList) {
      Uint8List? artwork = await _audioQuery.queryArtwork(
        audio.id,
        ArtworkType.AUDIO,
        size: 200,
      );

      songs.add(
        Song(
          path: audio.uri ?? '',
          title: audio.title,
          artist: audio.artist ?? 'Unknown Artist',
          albumName: audio.album ?? 'Unknown Album',
          totalDur: Duration(milliseconds: audio.duration ?? 0),
          albumCover: artwork,
        ),
      );
    }
    return songs;
  }

  // getters
  bool get hasPermission => _hasPermission;
}
