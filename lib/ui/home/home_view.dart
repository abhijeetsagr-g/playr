import 'package:flutter/material.dart';
import 'package:playr/core/common/album_art.dart';
import 'package:playr/core/utils/format_dur.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    return Consumer<FileProvider>(
      builder: (context, fileProvider, child) {
        if (fileProvider.isLoading) {
          return CircularProgressIndicator.adaptive();
        }

        if (fileProvider.allSongs.isEmpty) {
          return Center(child: Text("No Songs Avaliable"));
        }

        return ListView.builder(
          padding: EdgeInsets.only(bottom: 50),
          itemCount: fileProvider.allSongs.length,
          itemBuilder: (context, index) {
            final song = fileProvider.allSongs.elementAt(index);

            return InkWell(
              onTap: () {
                // Navigator.push(context, slideUpRoute(PlayerView()));
                music.playPlaylist(fileProvider.allSongs, index);
              },
              child: ListTile(
                textColor: music.currentIndex == index
                    ? Colors.purpleAccent
                    : null,
                leading: AlbumArt(size: Size(44, 44), artwork: song.albumCover),
                title: Text(song.title),
                subtitle: Text("${song.artist} . ${song.albumName}"),
                trailing: Text(formatDur(song.totalDur)),
              ),
            );
          },
        );
      },
    );
  }
}
