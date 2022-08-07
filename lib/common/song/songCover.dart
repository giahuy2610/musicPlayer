import 'package:flutter/material.dart';
import '../../themes/defaultValue.dart';
import 'package:provider/provider.dart';
import '../../providers/control.dart';

class SongCover extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String temp =
        'https://img.freepik.com/premium-vector/simple-cartoon-disk-icon_576934-18.jpg';
    if (context.watch<Control>().currentSong.name != null) {
      temp = context.watch<Control>().currentSong.coverImage;
    }

    return Container(
      width: DefaultValue.songCoverWidth,
      height: DefaultValue.songCoverHeight,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20), // Image border
        child: SizedBox.fromSize(
          size: Size.fromRadius(48), // Image radius
          child: Image.network(temp, fit: BoxFit.cover),
        ),
      ),
    );
  }
}
