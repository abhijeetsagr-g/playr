import 'package:flutter/material.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  @override
  void initState() {
    if (mounted) {
      Future.microtask(
        () => Provider.of<FileProvider>(context, listen: false).init(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    return Scaffold(
      body: Center(
        child: Consumer<FileProvider>(
          builder: (context, fileProvider, child) {
            if (fileProvider.isLoading) {
              return CircularProgressIndicator.adaptive();
            }

            if (fileProvider.allSongs.isEmpty) {
              return Center(child: Text("No Songs Avaliable"));
            }
            return ListView.builder(
              itemCount: fileProvider.allSongs.length,
              itemBuilder: (context, index) {
                final song = fileProvider.allSongs.elementAt(index);

                return InkWell(
                  onTap: () => music.playPlaylist(fileProvider.allSongs, index),
                  child: ListTile(
                    title: Text(song.title),
                    trailing: Icon(
                      music.currentIndex == index && music.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
