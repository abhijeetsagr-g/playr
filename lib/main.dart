import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:playr/logic/services/playback_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final audioHandler = await AudioService.init(
    builder: () => PlaybackService(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.zeenfic.playr.audio',
      androidNotificationChannelName: 'Playr',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // themeMode: ThemeMode.dark,
      // darkTheme: MyTheme.darkTheme,
      // home: SplashPage(),
    );
  }
}
