import 'package:flutter/material.dart';
import '../../themes/defaultValue.dart';
import './audioControl.dart';
import 'package:provider/provider.dart';
import '../../providers/control.dart';
import '../lyric/lyricDisplay.dart';

class Player extends StatefulWidget {
  const Player({
    Key? key,
  }) : super(key: key);

  @override
  State<Player> createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  bool selected = false;

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!context.read<Control>().isZoomIn_)
        context.read<Control>().changeZoomInToTrue();
      },
      child: AnimatedContainer(
          constraints: BoxConstraints(
            minHeight: context.watch<Control>().isZoomIn
                ? DefaultValue.screenHeight * 0.75
                : DefaultValue.screenHeight * 0.5,
          ),
          duration: Duration(milliseconds: 500),
          padding: EdgeInsets.only(
              top: DefaultValue.songCoverHeight / 2 + 20,
              bottom: 20,
              left: 20,
              right: 20),
          decoration: BoxDecoration(
            borderRadius: context.watch<Control>().isZoomIn ? BorderRadius.only(topRight: Radius.circular(20.0), topLeft: Radius.circular(20.0)) : BorderRadius.circular(20.0),
            color: DefaultValue.backgroundColorPlayer,
            boxShadow: [
              BoxShadow(
                color: Colors.lightBlue.shade300,
                offset: const Offset(
                  3.0,
                  5.0,
                ),
                blurRadius: 20.0,
                spreadRadius: 0.7,
              ), //BoxShadow
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                      context.watch<Control>().currentSong.name == null
                          ? 'NAME'
                          : context
                              .watch<Control>()
                              .currentSong
                              .name
                              .toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        //fontFamily:
                      )),
                  Text(
                    context.watch<Control>().currentSong.artists == null
                        ? 'ARTISTS'
                        : context
                            .watch<Control>()
                            .currentSong
                            .artists
                            .toUpperCase(),
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              LyricDisplay(),
              AudioControl(),
            ],
          )),
    );
  }
}
