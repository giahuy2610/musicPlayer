import 'package:flutter/material.dart';
import '../playList/playList.dart';
import '../../themes/defaultValue.dart';
import './matchedResutlItem.dart';

class searchingDialog extends StatefulWidget {
  final BuildContext ctx;

  const searchingDialog(
    this.ctx, {
    Key? key,
  }) : super(key: key);

  @override
  State<searchingDialog> createState() => _searchingDialog(this.ctx);
}

class _searchingDialog extends State<searchingDialog> {
  late Future<PlayList> futurePlaylist;
  final BuildContext ctx;
  get getCtx => ctx;
  var key = '';
  final searchFieldController = TextEditingController();

  _searchingDialog(this.ctx);

  Widget build(BuildContext context) {
    return Container(
        //color: Colors.white,
        width: DefaultValue.screenWidth,
        child: Column(
          children: [
            TextField(
              controller: searchFieldController,
              autofocus: true,
              style: TextStyle(color: Colors.white),
              decoration: new InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(100.0))),
                  hintStyle: TextStyle(color: Colors.white),
                  suffixIcon: new IconButton(
                      color: Colors.white,
                      onPressed: () {
                        setState(() {
                          this.key = searchFieldController.value.text;
                        });
                      },
                      icon: Icon(Icons.search)),
                  hintText: 'Search...'),
            ),
            this.key != ''
                ? FutureBuilder<PlayList>(
                    future: fetchPlayListMatchedBySearch(this.key),
                    builder: (context, snapshot) {

                      if (snapshot.hasData) {
                        return Container(
                          color: Colors.white,
                          margin: EdgeInsets.only(top: 10),
                          width: DefaultValue.screenWidth,
                          height: DefaultValue.screenWidth * 0.5,
                          child: ListView(
                              padding: const EdgeInsets.all(8),
                              children: [
                                for (var song in snapshot.data!.songsInList)
                                  matchedResultItem(song)
                              ]),
                        );
                      } else if (snapshot.hasError) {
                        return Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 10),
                            color: Colors.white,
                            width: DefaultValue.screenWidth,
                            height: 50,
                            child: Text("No result found"));
                      }

                      // By default, show a loading spinner.
                      return const CircularProgressIndicator();
                    })
                : Container()
          ],
        ));
  }
}
