import 'package:flutter/material.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:playr/ui/home/home_view.dart';
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
    return Scaffold(
      body: SafeArea(
        child: Consumer<FileProvider>(
          builder: (context, fileProvider, child) {
            if (fileProvider.isLoading) {
              return CircularProgressIndicator.adaptive();
            }

            if (fileProvider.allSongs.isEmpty) {
              return Center(child: Text("No Songs Avaliable"));
            }

            return HomeView();
          },
        ),
      ),
    );
  }
}
