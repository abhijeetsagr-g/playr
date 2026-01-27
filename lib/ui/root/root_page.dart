import 'package:flutter/material.dart';
import 'package:playr/core/common/slide_up_route.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/ui/home/home_view.dart';
import 'package:playr/ui/player/player_view.dart';
import 'package:playr/ui/root/mini_player.dart';
import 'package:provider/provider.dart';

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _currentIndex = 0;
  bool _isPlayerVisible = true;

  final List<String> _pageName = ["Library", "Playlists"];
  final List<Widget> _pages = [HomeView()];

  AppBar _appBar() => AppBar(
    backgroundColor: Colors.black,
    titleSpacing: 1,
    centerTitle: false,
    leading: Icon(Icons.library_music),
    title: Text(
      _pageName[_currentIndex],
      style: TextStyle(fontSize: 24, letterSpacing: 2),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 16.0),
        child: Icon(Icons.search),
      ),
    ],
  );

  @override
  void initState() {
    if (mounted) {
      Future.microtask(
        // ignore: use_build_context_synchronously
        () => Provider.of<FileProvider>(context, listen: false).init(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),

      body: Stack(
        children: [
          Positioned.fill(
            child: Consumer<FileProvider>(
              builder: (context, fileProvider, child) {
                if (fileProvider.isLoading) {
                  return CircularProgressIndicator.adaptive();
                }

                if (fileProvider.allSongs.isEmpty) {
                  return Center(child: Text("No Songs Avaliable"));
                }

                return _pages[_currentIndex];
              },
            ),
          ),

          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: MiniPlayer(
              changePage: () {
                Navigator.push(context, slideUpRoute(const PlayerView()));
              },
            ),
          ),
        ],
      ),
    );
  }
}
