import 'package:flutter/material.dart';
import 'package:playr/ui/root/root_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // final audioHandler = await AudioService.init(
  //   builder: () => MyAudioHandler(),
  //   config: const AudioServiceConfig(
  //     androidNotificationChannelId: 'com.zeenfic.playr.audio',
  //     androidNotificationChannelName: 'Music Playback',
  //   ),
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: RootPage());
  }
}
