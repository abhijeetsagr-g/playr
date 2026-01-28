import 'package:flutter/material.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/ui/home/album_row.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final albums = context.watch<FileProvider>().albums;

    if (albums.isEmpty) {
      return const Center(child: Text('No albums found'));
    }

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              'Albums',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),

        SliverToBoxAdapter(child: AlbumsRow(albums: albums)),

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }
}
