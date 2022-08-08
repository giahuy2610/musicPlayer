import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../song/song.dart';
import '../../providers/control.dart';

class matchedResultItem extends StatelessWidget {
  final Song thisSong;
  matchedResultItem(this.thisSong);

  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.5),
        child: InkWell(
          onTap: () {
            print(thisSong.name);
            context.read<Control>().changeSong(this.thisSong);
            Navigator.of(context).pop();
          },
          child: Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(35), // Image radius
                child: Image.network(thisSong.coverImage, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Text(
                      thisSong.name,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(thisSong.artists,
                        softWrap: false, overflow: TextOverflow.fade)
                  ],
                ),
              ),
            )
          ]),
        ));
  }
}
