import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playr/core/configs/my_theme.dart';
import 'package:playr/logic/providers/file_provider.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:playr/logic/services/file_service.dart';
import 'package:playr/logic/services/music_service.dart';
import 'package:provider/provider.dart';
import 'package:playr/ui/root/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // initialize music services
  final musicService = await AudioService.init(
    builder: () => MusicService(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'playr.music',
      androidNotificationChannelName: 'Music Playback',
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FileProvider(FileService()),
        ),
        ChangeNotifierProvider(
          create: (context) => MusicProvider(musicService),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: MyTheme.darkTheme,
      home: RootPage(),
    );
  }
}
