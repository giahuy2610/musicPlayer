import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/control.dart';
import '../../download.dart';

class MoreSubMenu extends StatelessWidget {
  final song;
  const MoreSubMenu(this.song, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: Icon(Icons.more_horiz_outlined),
      itemBuilder: (context) => [
        PopupMenuItem(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              song.isFavorite ? 'Remove from favorite' : 'Add to favorite',
              textAlign: TextAlign.left,
            ),
            song.isFavorite
                ? Icon(Icons.heart_broken_sharp)
                : FaIcon(
                    FontAwesomeIcons.heart,
                  ),
          ],
        )),

        PopupMenuItem(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              song.isDownloaded ? 'Delete' : 'Download',
            ),
            Icon(song.isDownloaded
                ? Icons.delete_rounded
                : Icons.download_rounded),
          ],
        )),
        PopupMenuItem(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(milliseconds: 400),
                content: Text("Not found detail"),
              ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Get info'),
                Icon(Icons.info_rounded),
              ],
            )),
        //PopupMenuItem(child: child)
      ],
    );
  }
}
