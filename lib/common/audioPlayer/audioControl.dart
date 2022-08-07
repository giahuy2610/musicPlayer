import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:provider/provider.dart';
import '../../providers/control.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//audio control

class AudioControl extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        //lyrics
        Row(),
        //second row: range control
        Column(
          children: [
            ValueListenableBuilder<ProgressBarState>(
              valueListenable: context.read<Control>().progressNotifier,
              builder: (_, value, __) {
                return ProgressBar(
                  progress: value.current,
                  buffered: value.buffered,
                  total: value.total,
                  onSeek: (Duration _currentDuration) {
                    context.read<Control>().player.seek(_currentDuration);
                  },
                );
              },
            ),
          ],
        ),
        //last row: controller (next song, previous, pause/play, mix, ..)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: context.watch<Control>().player.volume == 0.0 ? const FaIcon(FontAwesomeIcons.volumeXmark) : const FaIcon(FontAwesomeIcons.volumeHigh),
              onPressed: () {
                context.read<Control>().changeVolume();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: context.watch<Control>().player.playing
                  ? const Icon(Icons.pause_circle_filled_rounded)
                  : const Icon(Icons.play_arrow),
              onPressed: () {
                context.read<Control>().playOrPause();
              },
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios_rounded),
              onPressed: () {},
            ),
            IconButton(
              icon: context.watch<Control>().player.loopMode.toString() == 'LoopMode.off' ? const FaIcon(FontAwesomeIcons.repeat, color: Colors.grey) : (context.watch<Control>().player.loopMode.toString() == 'LoopMode.all' ? const FaIcon(FontAwesomeIcons.repeat) : const FaIcon(FontAwesomeIcons.arrowRotateRight)),
              onPressed: () {
                //change looping status
                context.read<Control>().changeLoop(context);
                print(context.read<Control>().player.loopMode);
              },
            ),
          ],
        ),
      ],
    );
  }
}
