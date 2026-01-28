import 'package:flutter/material.dart';
import 'package:playr/core/common/slide_up_route.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/ui/home/home_view.dart';
import 'package:playr/ui/player/player_view.dart';
import 'package:playr/ui/root/mini_player.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Consumer<FileProvider>(
                builder: (context, fileProvider, child) {
                  if (fileProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return HomeView();
                },
              ),
            ),

            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: MiniPlayer(
                changePage: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayerView()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
