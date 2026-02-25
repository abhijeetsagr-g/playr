import 'package:flutter/material.dart';
import 'package:playr/ui/home/widget/song_list.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SongList());
  }
}
