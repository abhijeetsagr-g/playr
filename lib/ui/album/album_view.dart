import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:playr/core/common/marquee_text.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:playr/ui/home/song_tile.dart';
import 'package:playr/ui/player/player_view.dart';
import 'package:provider/provider.dart';

class AlbumView extends StatelessWidget {
  const AlbumView({super.key, required this.album});

  final AlbumModel album;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<SongModel>>(
        future: context.read<FileProvider>().fetchSongsByAlbum(album.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Failed to load songs'));
          }

          final songs = snapshot.data ?? [];

          return CustomScrollView(
            slivers: [
              _AlbumHeader(album: album),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Text(
                    '${songs.length} songs',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return SongTile(
                    song: songs[index],
                    onTap: () {
                      context.read<MusicProvider>().playPlaylist(songs, index);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PlayerView()),
                      );
                    },
                  );
                }, childCount: songs.length),
              ),

              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          );
        },
      ),
    );
  }
}

class _AlbumHeader extends StatelessWidget {
  const _AlbumHeader({required this.album});

  final AlbumModel album;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 260,
      backgroundColor: Colors.black,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            QueryArtworkWidget(
              id: album.id,
              type: ArtworkType.ALBUM,
              artworkFit: BoxFit.cover,
              nullArtworkWidget: Container(color: Colors.grey.shade900),
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.transparent, Colors.black87],
                ),
              ),
            ),

            // ✅ Marquee placed manually
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: MarqueeText(
                text: album.album,
                maxWidth: MediaQuery.of(context).size.width - 32,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
