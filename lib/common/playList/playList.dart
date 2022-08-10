import 'package:flutter/material.dart';

import '../../common/song/song.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../providers/control.dart';

class PlayList {
  var name;
  var code;
  static const playListResourcePrefix =
      'https://apizingmp3.herokuapp.com/api/detailplaylist?id={';
  static const playListResourceSubfix = '}';
  var description;
  var createdOn;
  List<Song> songsInList = List<Song>.empty(growable: true);
  var rawData;
  var thumbnail;

  PlayList(
      {required this.name,
      required this.code,
      this.description,
      this.createdOn,
      required this.songsInList});

  factory PlayList.fromJson(Map<String, dynamic> json) {
    var temp = json['data']['song']['items'];
    List<Song> tempSongInList = List<Song>.empty(growable: true);
    for (final e in temp) {
      tempSongInList.add(Song(
          name: e['title'],
          code: e['encodeId'],
          artists: e['artistsNames'],
          coverImage: e['thumbnail'],
          duration: e['duration'],
          hasLyric: e['hasLyric']));
    }
    return PlayList(
      name: json['data']['title'],
      code: json['data']['encodeId'],
      songsInList: tempSongInList,
    );
  }

  factory PlayList.fromJsonBySearch(Map<String, dynamic> json) {
    var temp = json['data']['songs'];
    List<Song> tempSongInList = List<Song>.empty(growable: true);
    for (final e in temp) {
      tempSongInList.add(Song(
          name: e['title'],
          code: e['encodeId'],
          artists: e['artistsNames'],
          coverImage: e['thumbnail'],
          duration: e['duration'],
          hasLyric: e['hasLyric']));
    }
    return PlayList(
      name: 'The matched playlist by search',
      code: 'matchedBySearch',
      songsInList: tempSongInList,
    );
  }

  //revert lyric json respopnse to data

}

Future<PlayList> fetchPlayList(String key) async {
  final response = await http.get(Uri.parse(
      'https://apizingmp3.herokuapp.com/api/detailplaylist?id={$key}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PlayList.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load playlist');
  }
}

Future<PlayList> fetchPlayListMatchedBySearch(String key) async {
  final response = await http.get(
      Uri.parse('https://apizingmp3.herokuapp.com/api/search?keyword={$key}'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return PlayList.fromJsonBySearch(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load playlist');
  }
}
