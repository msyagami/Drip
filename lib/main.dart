import 'dart:io';
import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:drip/datasource/audioplayer/audioplayer.dart';
import 'package:drip/navigationstuff/navigatorstackpageone.dart';
import 'package:drip/screens/explorepage.dart';
import 'package:provider/provider.dart';

import 'package:drip/screens/searchpagerevision.dart';
import 'package:drip/widgets/bottomplayercontrols.dart';
import 'package:drip/widgets/noresult.dart';

import 'package:drip/widgets/topbar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:fluent_ui/fluent_ui.dart' as fluent;

import 'datasource/audioplayer/audioplayer2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.setMinWindowSize(const Size(1000, 600));

  if (Platform.isWindows) {
    await Hive.initFlutter('Drip');
  } else {
    await Hive.initFlutter();
  }

  await openHiveBox('settings');
  await openHiveBox('Favorite Songs');
  await openHiveBox('cache', limit: true);
  runApp(const MyApp());
}

Future<void> openHiveBox(String boxName, {bool limit = false}) async {
  final box = await Hive.openBox(boxName).onError((error, stackTrace) async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String dirPath = dir.path;
    File dbFile = File('$dirPath/$boxName.hive');
    File lockFile = File('$dirPath/$boxName.lock');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      dbFile = File('$dirPath/mibe/$boxName.hive');
      lockFile = File('$dirPath/mibd/$boxName.lock');
    }
    await dbFile.delete();
    await lockFile.delete();
    await Hive.openBox(boxName);
    throw 'Failed to open $boxName Box\nError: $error';
  });
  // clear box if it grows large
  if (limit && box.length > 500) {
    box.clear();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drip',
      theme: ThemeData(
        //sliderTheme: Slidert,
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: ChangeNotifierProvider(
          create: (BuildContext context) => AudioPlayerControls(),
          child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late int _selectedIndex;

  late PageController _pageController;
  late List<Widget> screens;
  late final AudioPlayerControls _audioPlayerControls;

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    screens = [
      FirstPageStack(),
      //const YouTubeHomeScreen(),
      SecondPageStack(),
      // const SearchPage(
      //   incomingquery: 'Home',
      // ),
      noResult('Error 404!'),
    ];
    _pageController = PageController(initialPage: _selectedIndex);

    _audioPlayerControls = AudioPlayerControls();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayerControls.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  double _sliderval = 20;

  @override
  Widget build(BuildContext context) {
    //super.build(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: WindowBorder(
        child: Row(
          children: [
            NavigationRail(
              elevation: 5,
              groupAlignment: 0.0,
              minWidth: 20,
              leading: const Text(
                'Drip',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
              ),
              // trailing: Icon(
              //   fluent.FluentIcons.settings,
              //   color: Colors.white,
              // ),
              backgroundColor: Colors.red.shade700.withRed(220),
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                  _pageController.animateToPage(index,
                      curve: Curves.fastLinearToSlowEaseIn,
                      duration: Duration(milliseconds: 600));
                  // _loadscreen = screens[_selectedIndex];

                  //TopBar();
                });
              },
              labelType: NavigationRailLabelType.selected,
              destinations: const <NavigationRailDestination>[
                NavigationRailDestination(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    label: Text(
                      'Home',
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: Icon(
                      fluent.FluentIcons.home,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      fluent.FluentIcons.home,
                      color: Colors.black,
                    )),
                NavigationRailDestination(
                    label: Text(
                      'Search',
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: Icon(
                      fluent.FluentIcons.search,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      fluent.FluentIcons.search,
                      color: Colors.black,
                    )),
                NavigationRailDestination(
                    label: Text(
                      'Playlists',
                      style: TextStyle(color: Colors.black),
                    ),
                    icon: Icon(
                      fluent.FluentIcons.stream_playlist,
                      color: Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.playlist_play,
                      color: Colors.black,
                    ))
              ],
            ),
            Expanded(
              child: Stack(
                fit: StackFit.loose,
                clipBehavior: Clip.none,
                children: [
                  Expanded(
                      child: PageView(
                    scrollDirection: Axis.vertical,
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: screens,
                  )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ClipRect(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                          child: SizedBox(
                            child: PlayerControls(),
                            width: double.infinity,
                            height: 80.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 53.5,
                      left: 5,
                      right: 5,
                      child: Consumer<AudioPlayerControls>(
                        builder: (_, audioplayerModel, child) => ProgressBar(
                          bufferedBarColor: Colors.red.shade200,
                          progressBarColor: Colors.red.shade700,
                          thumbColor: Colors.red.shade700,
                          progress: audioplayerModel.position,
                          buffered: audioplayerModel.bufferposition,
                          total: audioplayerModel.totalDuration,
                          onSeek: (duration) {
                            audioplayerModel.seek(duration);
                          },
                        ),
                      )),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10)),
                          child: const TopBar()),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
        color: Colors.red.shade800.withOpacity(0.8),
        width: 0,
        //child: SideBar(),
      ),
    );
  }
}

// class ConstantScrollBehavior extends ScrollBehavior {
//   const ConstantScrollBehavior();
//
//   @override
//   Widget buildScrollbar(
//           BuildContext context, Widget child, ScrollableDetails details) =>
//       child;
//
//   @override
//   Widget buildOverscrollIndicator(
//           BuildContext context, Widget child, ScrollableDetails details) =>
//       child;
//
//   @override
//   TargetPlatform getPlatform(BuildContext context) => TargetPlatform.macOS;
//
//   @override
//   ScrollPhysics getScrollPhysics(BuildContext context) =>
//       const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
// }
