import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../themes/defaultValue.dart';
import '../../providers/control.dart';
import 'package:flutter_lyric/lyrics_reader.dart';

class LyricDisplay extends StatelessWidget {
  double sliderProgress = 0;
  int playProgress = 0;
  double max_value = 211658;
  bool isTap = false;

  bool useEnhancedLrc = false;
  var playing = false;
  var a = """d""";
  // var lyricModel = LyricsModelBuilder.create()
  //     .bindLyricToMain(a)
  //     .bindLyricToExt(a)
  //     .getModel();
  var lyricUI = UINetease();

  @override
  Widget build(BuildContext context){
    print('crr' + context.watch<Control>().currentMiliseconds.toString());
    return AnimatedContainer(
      duration: Duration(milliseconds: 700),
      width: DefaultValue.screenWidth,
      constraints: BoxConstraints(
        maxHeight: context.watch<Control>().isZoomIn_ ? DefaultValue.screenHeight*0.35 : 45
      ),
      //padding: EdgeInsets.all(2),
      decoration: BoxDecoration(color: Colors.deepPurple,borderRadius: BorderRadius.all(Radius.circular(15))),
      child: LyricsReader(
        model: LyricsModelBuilder.create()
            .bindLyricToMain(context.watch<Control>().normalLyric)
            .getModel(),
        position: context.watch<Control>().currentMiliseconds,
        lyricUi: lyricUI,
        playing: playing,
        size: Size(double.infinity, MediaQuery.of(context).size.height / 2),
        emptyBuilder: () => Center(
          child: Text(
            "No lyrics",
            style: lyricUI.getOtherMainTextStyle(),
          ),
        ),
      )


      ,
    );
  }

}

