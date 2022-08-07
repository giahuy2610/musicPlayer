import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../common/song/song.dart';
import 'dart:async';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class Control extends ChangeNotifier {
  //bool _isPlaying = false;
  //bool get isPlaying => _isPlaying;
  Song _currentSong = Song();
  Song get currentSong => _currentSong;
  final _player = AudioPlayer();
  get player => _player;
  int currentMiliseconds_ = 0;
  int get currentMiliseconds => currentMiliseconds_;
  String normalLyric_ = """""";
  String advancedLyric = """""";
  get normalLyric => normalLyric_;
  set SetNormalLyric(String value) => this.normalLyric_ = value;
  bool isZoomIn_ = false;
  get isZoomIn => this.isZoomIn_;
  bool isDarkMode_ = false;
  get isDartMode => this.isDarkMode_;

  bool isLogIn = false;



  final progressNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      buffered: Duration.zero,
      total: Duration.zero,
    ),
  );

  //init global audio player value
  Future<void> _init() async {
    if (_currentSong.name == null) return;
    // Inform the operating system of our app's audio attributes etc.
    // We pick a reasonable default for an app that plays speech.
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    // Listen to errors during playback.
    _player.playbackEventStream.listen((event) {},
        onError: (Object e, StackTrace stackTrace) {
      print('A stream error occurred: $e');
    });
    // Try to load audio from a source and catch any errors.
    try {
      //get mp3
      await _currentSong.fetchPlayList();
      //get lyric if have
      print(_currentSong.hasLyric);
      _currentSong.hasLyric == true ? fetchLyric(_currentSong.code) : false;

      await _player.setAudioSource(
          AudioSource.uri(Uri.parse(_currentSong.songResource)));
    } catch (e) {
      _player.pause();
      notifyListeners();
      await _player.setAudioSource(AudioSource.uri(
          Uri.file(r'lib/providers/emptyMp3.mp3', windows: false)));

      print("Error loading audio source: $e");
    }

    _player.positionStream.listen((position) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: position,
        buffered: oldState.buffered,
        total: oldState.total,
      );
      changeProcessMiliseconds(progressNotifier.value.current);
    });

    _player.bufferedPositionStream.listen((bufferedPosition) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: bufferedPosition,
        total: oldState.total,
      );
    });

    _player.durationStream.listen((totalDuration) {
      final oldState = progressNotifier.value;
      progressNotifier.value = ProgressBarState(
        current: oldState.current,
        buffered: oldState.buffered,
        total: totalDuration ?? Duration.zero,
      );
    });

    _player.playerStateStream.listen((playerState) {
      final isPlaying = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        //buttonNotifier.value = ButtonState.loading
      } else if (!isPlaying) {
        //_player.pause();
      } else if (processingState != ProcessingState.completed) {
        //_player.play();
      } else {
        // completed
        _player.seek(Duration.zero);
        _player.pause();
        notifyListeners();
      }
    });
  }

  get init => _init();

  void dispose() {
    // Release decoders and buffers back to the operating system making them
    // available for other apps to use.
    _player.dispose();
    super.dispose();
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Release the player's resources when not in use. We use "stop" so that
      // if the app resumes later, it will still remember what position to
      // resume from.
      _player.stop();
    }
  }

  void changeSong(Song promiseSong) {
    _currentSong = promiseSong;
    _init();
    notifyListeners();
  }

  void changeLoop(BuildContext context) {
    if (_player.loopMode.toString() == 'LoopMode.off') {
      _player.setLoopMode(LoopMode.all);
    } else if (_player.loopMode.toString() == 'LoopMode.all') {
      _player.setLoopMode(LoopMode.one);
    } else {
      _player.setLoopMode(LoopMode.off);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: Duration(milliseconds: 400),
      content: Text("The current looping mode: ${_player.loopMode}"),
    ));
    notifyListeners();
  }

  void changeVolume() {
    if (_player.volume == 100.0)
    //   _player.setVolume(50.0);
    // else if (_player.volume == 50.0)
      _player.setVolume(0.0);
    else
      _player.setVolume(100.0);
    notifyListeners();
  }

  void nextSong() {}

  void previousSong() {}

  void changeShuffingMode() {
    print(_player.shuffleModeEnabled.toString());
  }

  void playOrPause() {
    !_player.playing ? _player.play() : _player.pause();
    notifyListeners();
  }

  void changeProcessMiliseconds(Duration value) {
    this.currentMiliseconds_ = value.inMilliseconds;
    notifyListeners();
  }

  void changeZoomInToTrue() {
    this.isZoomIn_ = true;
    notifyListeners();
  }

  void changeZoomInToFalse() {
    this.isZoomIn_ =false;
    notifyListeners();
  }

  void changeDarkMode(bool value) {
    this.isDarkMode_ = value;
    print("dark mode is " + this.isDarkMode_.toString());
    notifyListeners();
  }

  Future<bool> fetchLyric(String key) async {
    final response = await http
        .get(Uri.parse('https://apizingmp3.herokuapp.com/api/lyric?id={$key}'));


    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      print('https://apizingmp3.herokuapp.com/api/lyric?id={$key}');
      var temp = jsonDecode(response.body)['data']['sentences'];
      var sentenceStr = """[ti:${currentSong.name}]
[ar:${currentSong.artists}]
[al:]
[by:]
[offset:0]
""";
      var sentenceStrAdvancedLyric = sentenceStr;
      int lastTime = -1;//time(miliseconds) of the last word of the previous sentence
      for (final e in temp) {
        var x = e['words'];
        if (lastTime > -1 && x[0]['startTime'] == lastTime) {
          sentenceStr += "[${convertMilisecondToMin(lastTime)}]\n";
        }

        sentenceStr += "[${convertMilisecondToMin(x[0]['startTime'])}]";

        for (final w in x) {
          sentenceStr += w['data'] + " ";
          sentenceStrAdvancedLyric += '(${w['startTime']},${w['endTime']})${w['data']} ';
        }

        lastTime =  x[x.length - 1]['endTime'].toInt();
        sentenceStr += '\n';
      }
      this.normalLyric_ = sentenceStr;
      this.advancedLyric = sentenceStrAdvancedLyric;
      notifyListeners();
      print(normalLyric);
      return true;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load playlist');
    }
  }
}

String convertMilisecondToMin(int value) {
  double second = value / 1000;
  int min = (second / 60).toInt();
  return NumberFormat("00", "en_US").format(min) +
      ':' +
      NumberFormat("00.00", "en_US").format(second - min * 60);
}
