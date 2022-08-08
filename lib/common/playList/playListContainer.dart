import 'package:flutter/material.dart';
import '../../common/song/songCoverDiscover.dart';
import './playList.dart';
import '../song/song.dart';
import '../../providers/control.dart';

class PlayListDislay extends StatefulWidget {
  final keyPlaylist;
  const PlayListDislay({Key? key, required this.keyPlaylist}) : super(key: key);

  @override
  State<PlayListDislay> createState() => _PlayListDislay(this.keyPlaylist);
}

class _PlayListDislay extends State<PlayListDislay> {
  late Future<PlayList> futurePlaylist;
  final ScrollController _sc =
      ScrollController(); //control to detect whenever client scroll
  var loadedSong =
      0; //total num of songs in current which be loaded by lazy load
  final maxSongLazyLoad = 7; //the number of songs are loaded per loading
  var keyPlaylist; //string encode of this playlist
  var totalSongsInPlayList; //a list store objects song() of this playlist be loaded by lazy load
  int?
      totalSongsInPlayListCanLoad; //the number of songs in playlist if load all
  var isLoading; //loading state
  var temp; //

  _PlayListDislay(this.keyPlaylist);

  @override
  void initState() {
    futurePlaylist = fetchPlayList(this.keyPlaylist);
    //lazy load listen
    _sc.addListener(() {
      if (_sc.offset == _sc.position.maxScrollExtent) {
        if (loadedSong < totalSongsInPlayListCanLoad!) _getMoreData();
      }
    });
    super.initState();
  }

  //lazy load will reduce to use network data because it only load cache 7 songs per playlist(with have 100 songs)
  //another songs only be loaded when client scrolled near to the max range of scrollList which will call to getMoreData function
  _getMoreData() {
    setState(() {
      isLoading = true;
    });
  }

  //this function to re-fetch songs in it and transfer to variable currentPlayList in provider Control
  //with currentPlayList, client can reach of easily current playlist which has a song is being played and easily to change different song
  //storing current playlist also support change to next/previous song or shuffle the playlist
  void change(BuildContext context) {
    //changeCurrentPlayList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PlayList>(
      future: futurePlaylist,
      builder: (context, snapshot) {
        print('build playlist');
        if (snapshot.hasData) {
          temp = snapshot.data!.songsInList;
          if (totalSongsInPlayList == null) {
            this.totalSongsInPlayListCanLoad = temp.length;
            totalSongsInPlayList = temp.sublist(0, maxSongLazyLoad);
          } else
            totalSongsInPlayList.addAll(temp.sublist(
                loadedSong,
                loadedSong + maxSongLazyLoad >= totalSongsInPlayListCanLoad!
                    ? totalSongsInPlayListCanLoad
                    : loadedSong + maxSongLazyLoad));
          print('playlist ${this.keyPlaylist} ${totalSongsInPlayList.length}');
          this.loadedSong = totalSongsInPlayList.length;

          return GestureDetector(
            onTap: () {
              print('click on playlist');
            },
            //margin: EdgeInsets.only(bottom: 20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                                  hasLyric: song.hasLyric,
                                  keyPlayListBelongTo: this.keyPlaylist)),

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
