import 'dart:io';
import 'package:lyrics_parser/lyrics_parser.dart';

final normalLyricFunc = () async {
  final file = File('./testLRC.lcr');
  final parser = LyricsParser.fromFile(file);
  await parser.ready();
  final result = await parser.parse();
  var str = """ """;
  for (final lyric in result.lyricList) {
    str += '[${lyric.startTimeMillisecond}] ${lyric.content}';
  }
  return str;
};

String normalLyric = 'normalLyricFunc()';

final normalLyric2 = """[ti:If I Didn't Love You]
[ar:Jason Aldean/Carrie Underwood]
[al:If I Didn't Love You]
[by:]
[offset:0]
""";

final issue1 = """""";

final advancedLyric = """""";

final transLyric = """""";
