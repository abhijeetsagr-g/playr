import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:playr/core/utils/format_dur.dart';
import 'package:playr/logic/bloc/player_bloc/player_bloc.dart';

class SeekBar extends StatefulWidget {
  const SeekBar({super.key, this.showText = true});
  final bool showText;

  @override
  State<SeekBar> createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double? _drag;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PlayerBloc>();

    return StreamBuilder<Duration?>(
      stream: bloc.duration,
      builder: (context, snapshot) {
        final duration = snapshot.data ?? Duration.zero;
        return StreamBuilder<Duration>(
          stream: bloc.position,
          builder: (context, snapshot) {
            final position = snapshot.data ?? Duration.zero;
            final sliderValue =
                _drag ??
                position.inMilliseconds.toDouble().clamp(
                  0.0,
                  duration.inMilliseconds.toDouble(),
                );

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    // padding: EdgeInsets.zero,
                    thumbColor: Colors.black,

                    activeTrackColor: Colors.black,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 6,
                    ),
                  ),
                  child: Slider(
                    value: sliderValue,
                    max: duration.inMilliseconds.toDouble(),
                    onChanged: (value) {
                      setState(() {
                        _drag = value;
                      });
                    },
                    onChangeEnd: (value) {
                      bloc.add(Seek(Duration(milliseconds: value.toInt())));
                      setState(() => _drag = null);
                    },
                  ),
                ),
                if (widget.showText)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDur(sliderValue.toInt())),
                        Text(
                          formatDur(duration.inMilliseconds),
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}
