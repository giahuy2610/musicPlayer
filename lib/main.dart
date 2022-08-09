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

class SearchBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(color: Colors.red, child: Text('search box')));
  }
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
    with SingleTickerProviderStateMixin {
  late Future<void> futurePlayer;
  late AnimationController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future downloader(String url) async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      print('local path is ' + baseStorage!.path.toString());

      await FlutterDownloader.enqueue(
        fileName: context.read<Control>().currentSong.name,
        url: url,
        savedDir: baseStorage.path,
        saveInPublicStorage: true,
        showNotification:
            true, // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      );
    }
  }

  ReceivePort _port = ReceivePort();

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      setState(() {});
    });

    FlutterDownloader.registerCallback(downloadCallback);
    super.initState();
    context.read<Control>().init;

    this.controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send!.send([id, status, progress]);
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild my app');
    return Scaffold(
      key: _scaffoldKey,
      drawer: Container(
        width: DefaultValue.drawerWidth,
        child: Drawer(
            child: ListView(
          children: [
            Container(
              //height: DefaultValue.screenHeight * 0.3,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                boxShadow: [
                  BoxShadow(
                    color: Colors.lightBlue.shade300,
                    offset: const Offset(
                      -10,
                      5,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 0.1,
                  ), //BoxShadow
                ],
              ),
              child: Stack(children: [
                Image.network(
                  'https://mcdn.wallpapersafari.com/medium/12/93/Ei0zCM.jpg',
                  fit: BoxFit.cover,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 50,
                      height: 50,
                      margin: EdgeInsets.only(right: 15.0),
                      decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          borderRadius:
                              BorderRadius.all(Radius.circular((505555)))),
                      child: Text(
                        'ND',
                        style: TextStyle(color: Colors.white, fontSize: 20.0),
                      ),
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Text('UserName'), Text('PremiumAccount')])
                  ],
                )
              ]),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Setting'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  // do something
                  return Setting();
                }));
              },
            ),
            ListTile(
              leading: context.select<Control, bool>((a) => a.isLogIn)
                  ? const Icon(Icons.logout_rounded)
                  : const Icon(Icons.login_rounded),
              title: context.select<Control, bool>((a) => a.isLogIn)
                  ? const Text('Log out')
                  : const Text('Log in'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            )
          ],
        ) // Populate the Drawer in the next step.
            ),
      ),
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
