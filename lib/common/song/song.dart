import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Song {
  static const songResourcePrefix =
      'https://apizingmp3.herokuapp.com/api/song?id={';
  static const songResourceSubfix = '}';
  var name;
  var code;
  var category;
  var artists;
  var coverImage;
  var songResourceRequestTo;
  var songResource;
  var lyrics;
  var isFavorite = false;
  var duration;
  var hasLyric;
  var rawLyricData;
  var lyric;
  var keyPlayListBelongTo;
  var isDownloaded = false;
  // encode of playlist which included this song
  // If this song is result of a search event, keyPlayListBelongTo is 'searchResult'
  // else if this song in storage, key in time is 'offlineSong'

  Song(
      {this.name,
      this.code,
      this.artists,
      this.category,
      this.coverImage,
      this.lyrics,
      this.duration,
      this.hasLyric,
      this.keyPlayListBelongTo}) {
    this.songResourceRequestTo =
        songResourcePrefix + (name == null ? '' : code) + songResourceSubfix;
  }

  //request to api to get mp3 source
  Future<bool> fetchPlayList() async {
    final response = await http.get(Uri.parse(songResourceRequestTo));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      if (jsonDecode(response.body)['err'] == -1110) {
        Fluttertoast.showToast(
            msg: jsonDecode(response.body)['msg'],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 12,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 13.0);
        print(jsonDecode(response.body)['msg']);
        return false;
      }

      this.songResource = jsonDecode(response.body)['data']['128'];
      print(songResource);
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load playlist');
    }
  }
}
