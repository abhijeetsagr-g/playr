import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/ui/album/album_view.dart';
import 'package:playr/ui/home/album_tile.dart';

class AlbumsRow extends StatelessWidget {
  const AlbumsRow({super.key, required this.albums});

  final List<AlbumModel> albums;

  @override
  Widget build(BuildContext context) {
    final displayList = albums.toList();

    return SizedBox(
      height: 160,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: displayList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 110,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AlbumView(album: displayList[index]),
                    ),
                  );
                },
                child: AlbumTile(album: displayList[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}
