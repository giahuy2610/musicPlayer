import 'package:flutter/material.dart';
import '../../themes/defaultValue.dart';
import './audioControl.dart';
import 'package:provider/provider.dart';
import '../../providers/control.dart';
import '../lyric/lyricDisplay.dart';
import './currentPlayListPage/moresubMenu.dart';
import '../song/song.dart';

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
              maxHeight: context.select<Control, bool>((a) => a.isZoomIn)
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
              borderRadius: context.select<Control, bool>((a) => a.isZoomIn)
                  ? BorderRadius.only(
                      topRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0))
                  : BorderRadius.circular(20.0),
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
            child: Container(
                child: PageView(clipBehavior: Clip.none, children: [
              SingleChildScrollView(
                child: context.select<Control, List<Song>?>(
                            (a) => a.currentPlayList) ==
                        null
                    ? Container()
                    : Column(
                        children: [
                          for (var song
                              in context.read<Control>().currentPlayList)
                            ListTile(
                              onTap: () {
                                context.read<Control>().changeSong(song);
                              },
                              title: Text(
                                song.name == null
                                    ? 'Name'
                                    : song.name.toUpperCase(),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  //fontFamily:
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                song.name == null ? 'Artists' : song.artists,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  //fontFamily:
                                ),
                                softWrap: false,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: MoreSubMenu(song),
                            ),
                        ],
                      ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SongInfo(),
                  LyricDisplay(),
                  AudioControl(),
                ],
              ),
            ]))));
  }
}

class SongInfo extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          context.select<Control, String?>((a) => a.currentSong.name) == null
              ? 'NAME'
              : context
                  .select<Control, String>((a) => a.currentSong.name)
                  .toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            //fontFamily:
          ),
          softWrap: false,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          context.select<Control, String?>((a) => a.currentSong.artists) == null
              ? 'ARTISTS'
              : context
                  .select<Control, String>((a) => a.currentSong.artists)
                  .toUpperCase(),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
