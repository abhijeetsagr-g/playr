import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playr/logic/bloc/media_bloc/media_cubit.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';
import 'package:playr/logic/services/playback_service.dart';
import 'package:playr/ui/home/view/home_view.dart';

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

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => PlayerBloc(audioHandler),
        ),
        BlocProvider<MediaCubit>(create: (_) => MediaCubit()..loadSongs()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeView());
  }
}
