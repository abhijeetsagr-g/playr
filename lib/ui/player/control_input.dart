import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:playr/logic/providers/music_provider.dart';
import 'package:provider/provider.dart';

class ControlInput extends StatelessWidget {
  const ControlInput({super.key});

  @override
  Widget build(BuildContext context) {
    final music = context.watch<MusicProvider>();
    return Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: music.toggleLoopOnce,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.repeat_one,
                    key: ValueKey(music.isLoopOnce),
                    color: music.isLoopOnce ? Colors.blue : Colors.white,
                  ),
                ),
              ),
              IconButton(
                iconSize: 45,
                color: Colors.white,
                icon: const Icon(Icons.skip_previous_rounded),
                onPressed: music.previous,
              ),

              Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      iconSize: 40,
                      color: Colors.black,
                      icon: Icon(
                        music.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      onPressed: music.togglePlayAndPause,
                    ),
                  )
                  .animate(target: music.isPlaying ? 1 : 0)
                  .scale(
                    begin: const Offset(1, 1),
                    end: const Offset(1.08, 1.08),
                    duration: 180.ms,
                  ),

              IconButton(
                iconSize: 45,
                color: Colors.white,
                icon: const Icon(Icons.skip_next_rounded),
                onPressed: music.next,
              ),

              IconButton(
                onPressed: music.toggleShuffle,
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.shuffle,
                    key: ValueKey(music.isShuffleEnabled),
                    color: music.isShuffleEnabled ? Colors.blue : Colors.white,
                  ),
                ),
              ),
            ],
          ),
        )
        .animate()
        .slideY(begin: 0.3, curve: Curves.easeOut)
        .fadeIn(duration: 400.ms);
  }
}
