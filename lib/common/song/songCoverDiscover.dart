import 'package:flutter/material.dart';
import '../../themes/defaultValue.dart';
import 'package:provider/provider.dart';
import '../../providers/control.dart';
import './song.dart';

class SongCoverDiscover extends StatelessWidget {
  Song songDetail_ = Song();
  get songDetail => songDetail_;
  var globalKeyPlayList;

  SongCoverDiscover({required this.songDetail_, this.globalKeyPlayList});

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            onTap: () {
              print("tap on cover song discovery " +
                  this.songDetail_.name +
                  ', code: ' +
                  this.songDetail_.code);
              context.read<Control>().changeSong(this.songDetail_);
              context.read<Control>().changeCurrentPlayList(
                  this.globalKeyPlayList!.currentState.temp);
            },
            child: Container(
              width: DefaultValue.screenWidth * 0.2,
              height: DefaultValue.screenWidth * 0.3,
              margin: const EdgeInsets.only(right: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20), // Image border
                child: SizedBox.fromSize(
                  size: Size.fromRadius(48), // Image radius
                  child: Image.network(this.songDetail_.coverImage,
                      fit: BoxFit.cover),
                ),
              ),
            )));
  }
}
