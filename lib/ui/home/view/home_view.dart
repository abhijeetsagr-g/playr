import 'package:flutter/material.dart';
import 'package:playr/ui/home/widget/mini_player.dart';
import 'package:playr/ui/home/widget/song_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SongList(),
            Positioned(bottom: 50, left: 0, right: 0, child: MiniPlayer()),
          ],
        ),
      ),
    );
  }
}
