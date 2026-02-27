import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();
    return StreamBuilder<bool>(
      stream: bloc.isPlaying,
      initialData: false,
      builder: (context, snapshot) {
        final isPlaying = snapshot.data ?? false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: () => bloc.add(SkipPrev()),
            ),
            Container(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: IconButton(
                iconSize: 36,
                icon: Icon(
                  isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  color: Colors.black,
                ),
                onPressed: () => bloc.add(TogglePlayPause()),
              ),
            ),
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.skip_next_rounded),
              onPressed: () => bloc.add(SkipNext()),
            ),
          ],
        );
      },
    );
  }
}
