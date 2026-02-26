import 'package:flutter/material.dart' hide RepeatMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';

class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayerBloc, PlayerState>(
      builder: (context, state) {
        final bloc = context.read<PlayerBloc>();

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Previous
            IconButton(
              iconSize: 36,
              icon: const Icon(Icons.skip_previous_rounded),
              onPressed: () => bloc.add(SkipPrev()),
            ),

            // Play / Pause
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),
              child: IconButton(
                iconSize: 36,
                icon: Icon(
                  state.isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
                  color: Colors.black,
                ),
                onPressed: () => bloc.add(TogglePlayPause()),
              ),
            ),

            // Next
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
