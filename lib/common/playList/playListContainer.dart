import 'package:flutter/material.dart';
import '../../common/song/songCoverDiscover.dart';
import './playList.dart';
import '../song/song.dart';

class PlayListDislay extends StatefulWidget {
  final keyPlaylist;
  const PlayListDislay({
    Key? key,
    required this.keyPlaylist
  }) : super(key: key);

  @override
  State<PlayListDislay> createState() => _PlayListDislay(this.keyPlaylist);
}

class _PlayListDislay extends State<PlayListDislay> {
  late Future<PlayList> futurePlaylist;
  final ScrollController _sc = ScrollController();
  var loadedSong = 0;
  final maxSongLazyLoad = 7;
  var keyPlaylist;
  var totalSongsInPlayList;
  var totalSongsInPlayListCanLoad;
  var isLoading;

  _PlayListDislay(this.keyPlaylist);

  @override
  void initState() {
    futurePlaylist = fetchPlayList(this.keyPlaylist);
    //lazy load listen
    _sc.addListener(() {
      if (_sc.offset == _sc.position.maxScrollExtent) {
        if (loadedSong < totalSongsInPlayListCanLoad)
        _getMoreData();
      }
    });
    super.initState();
  }

  _getMoreData() {
    setState(() {
      isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlayList>(
      future: futurePlaylist,
      builder: (context, snapshot) {
        print('build playlist');
        if (snapshot.hasData) {
          var temp = snapshot.data!.songsInList;
          if (totalSongsInPlayList == null)  {
            this.totalSongsInPlayListCanLoad = temp.length;
            totalSongsInPlayList = temp.sublist(0,maxSongLazyLoad);
          }
          else
          totalSongsInPlayList.addAll(temp.sublist(loadedSong,loadedSong+maxSongLazyLoad >= totalSongsInPlayListCanLoad ? totalSongsInPlayListCanLoad : loadedSong+maxSongLazyLoad));
          print(totalSongsInPlayList.length);
          this.loadedSong = totalSongsInPlayList.length;

          return Container(
            //margin: EdgeInsets.only(bottom: 20.0),
            child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    snapshot.data!.name,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SingleChildScrollView(
                      controller: _sc,
                      scrollDirection: Axis.horizontal,
                      child: Row(children: [
                        for (var song in totalSongsInPlayList)
                          Column(
                            children: [
                              SongCoverDiscover(
                                  songDetail_: Song(
                                      name: song.name,
                                      code: song.code,
                                      artists: song.artists,
                                      coverImage: song.coverImage,
                                      hasLyric: song.hasLyric)),
                              //Text(song.name)
                            ],
                          )
                      ]))
                ]),
          );

        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
