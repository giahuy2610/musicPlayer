import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:untitled/common/searchingDialog/searchingDialog.dart';
import './common/AudioPlayer/player.dart';
import 'themes/defaultValue.dart';
import './common/playList/playListContainer.dart';
import './common/song/songCover.dart';
import 'package:provider/provider.dart';
import './providers/control.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import './common/setting/setting.dart';
import './common/drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => Control()),
  ], child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Music App',
        debugShowCheckedModeBanner: false,
        themeMode: context.select<Control, bool>((a) => a.isDarkMode_)
            ? ThemeMode.dark
            : ThemeMode.light,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
          primaryColor: Colors.blue[600],
          brightness: Brightness.light,
          backgroundColor: Colors.grey[100],
          fontFamily: 'Karla',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.lightBlue,
          primaryColor: Colors.blue[300],
          brightness: Brightness.dark,
          backgroundColor: Colors.grey[900],
          fontFamily: 'Karla',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // theme: ThemeData(
        //   textTheme: TextTheme(button: TextStyle(color: Colors.black54)),
        //     colorScheme: ColorScheme.fromSwatch().copyWith(
        //   primary: context.watch<Control>().isDarkMode_
        //       ? DefaultValue.backgroundColorDefaultDark
        //       : DefaultValue.backgroundColorDefault,
        // )),
        home: Stack(children: [
          const MyHomePage(),
        ]));
  }
}

class ProgressBarState {
  ProgressBarState({
    required this.current,
    required this.buffered,
    required this.total,
  });
  final Duration current;
  final Duration buffered;
  final Duration total;
}

//DiscoveryScrollPage
class DiscoveryScrollPage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Expanded(
        child: SingleChildScrollView(
            child: Container(
      width: DefaultValue.screenWidth,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PlayListDislay(key: GlobalKey(), keyPlaylist: 'ZWZB969E'),
          PlayListDislay(key: GlobalKey(), keyPlaylist: 'ZWZB969F'),
          PlayListDislay(key: GlobalKey(), keyPlaylist: 'ZWZB96C8')
        ],
      ),
    )));
  }
}

//main body include the song player and songs discovery scroll page
class MainBody extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        height: DefaultValue.screenHeight * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20)),
          color: DefaultValue.backgroundColorDiscoveryScreen,
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(children: [
              Player(),
              DiscoveryScrollPage(),
            ]),
            Positioned(
                top: -DefaultValue.songCoverHeight / 2,
                left: DefaultValue.screenWidth / 2 -
                    DefaultValue.songCoverWidth / 2,
                child: Center(child: SongCover())),
          ],
        ));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with
        SingleTickerProviderStateMixin // with SingleTickerProviderStateMixin to get vsync used in animation controller
{
  late AnimationController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey =
      new GlobalKey<ScaffoldState>(); //using make drawer

  @override
  void initState() {
    this.controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild my app');
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerContainer(),
      resizeToAvoidBottomInset: false,
      backgroundColor: DefaultValue.backgroundColorDefault,
      appBar: AppBar(
          elevation: 0,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_outlined),
              onPressed: () => {
                    if (!context.read<Control>().isZoomIn)
                      _scaffoldKey.currentState?.openDrawer(),
                    context.read<Control>().changeZoomInToFalse(),
                    if (context.read<Control>().isZoomIn) controller.forward(),

                    // this.downloader(
                    //     context.read<Control>().currentSong.songResource)
                  }),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    elevation: 0.0,
                    backgroundColor: Colors.transparent,
                    actions: <Widget>[
                      searchingDialog(ctx),
                    ],
                  ),
                );
              },
            ),
          ]),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [MainBody()],
        ),
      ),
    );
  }
}
