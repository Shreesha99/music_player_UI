import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(HomePage());

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: StackBuilder()));
  }
}

class StackBuilder extends StatefulWidget {
  StackBuilder({Key key}) : super(key: key);

  _StackBuilderState createState() => _StackBuilderState();
}

class _StackBuilderState extends State<StackBuilder>
    with TickerProviderStateMixin {
  AnimationController paneController;
  AnimationController playPauseController;
  Animation<double> paneAnimation;
  Animation<double> albumImageAnimation;
  Animation<double> albumImageBlurAnimation;
  Animation<Color> songsContainerColorAnimation;
  Animation<Color> songsContainerTextColorAnimation;

  bool isAnimCompleted = false;
  bool isSongPlaying = false;

  @override
  void initState() {
    super.initState();
    paneController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    paneAnimation = Tween<double>(begin: -250, end: 0.0)
        .animate(CurvedAnimation(parent: paneController, curve: Curves.easeIn));
    albumImageAnimation = Tween<double>(begin: 1.0, end: 0.7)
        .animate(CurvedAnimation(parent: paneController, curve: Curves.easeIn));
    albumImageBlurAnimation = Tween<double>(begin: 0.0, end: 10.0)
        .animate(CurvedAnimation(parent: paneController, curve: Curves.easeIn));
    songsContainerColorAnimation =
        ColorTween(begin: Colors.black87, end: Colors.white.withOpacity(0.5))
            .animate(paneController);
    songsContainerTextColorAnimation =
        ColorTween(begin: Colors.white, end: Colors.black87)
            .animate(paneController);
    playPauseController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
  }

  animationInit() {
    if (isAnimCompleted) {
      paneController.reverse();
    } else {
      paneController.forward();
    }
    isAnimCompleted = !isAnimCompleted;
  }

  playSong() {
    if (isSongPlaying == true) {
      playPauseController.reverse();
    } else {
      playPauseController.forward();
    }
    isSongPlaying = !isSongPlaying;
  }

  Widget stackBody(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        FractionallySizedBox(
          alignment: Alignment.topCenter,
          heightFactor: albumImageAnimation.value,
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: ExactAssetImage('lib/assets/mm.jpg'),
                    fit: BoxFit.cover)),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: albumImageBlurAnimation.value,
                  sigmaY: albumImageBlurAnimation.value),
              child: Container(
                color: Colors.white.withOpacity(0.0),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: paneAnimation.value,
          child: GestureDetector(
            onTap: () {
              animationInit();
            },
            child: Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                color: songsContainerColorAnimation.value,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Now Playing",
                      style: TextStyle(
                          color: songsContainerTextColorAnimation.value),
                    ),
                  ),
                  Text(
                    "Dil Mein Mars Hai - Mission Mangal",
                    style: TextStyle(
                        color: songsContainerTextColorAnimation.value,
                        fontSize: 16.0),
                  ),
                  Text(
                    "Benny Dayal,Vibha Saraf",
                    style: TextStyle(
                        color: songsContainerTextColorAnimation.value,
                        fontSize: 12.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Icon(
                          Icons.skip_previous,
                          size: 40.0,
                          color: songsContainerTextColorAnimation.value,
                        ),
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              playSong();
                            },
                            child: AnimatedIcon(
                              icon: AnimatedIcons.play_pause,
                              progress: playPauseController,
                              size: 40.0,
                              color: songsContainerTextColorAnimation.value,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.skip_next,
                          size: 40.0,
                          color: songsContainerTextColorAnimation.value,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height / 2,
                    child: ListView.builder(
                        itemCount: 10,
                        itemBuilder: (BuildContext context, index) {
                          return Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: 60.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: ExactAssetImage(
                                            'lib/assets/mm.jpg'),
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Another song name",
                                    style: TextStyle(
                                      color: songsContainerTextColorAnimation
                                          .value,
                                    ),
                                  ),
                                  Text(
                                    "Singer name | 5.45",
                                    style: TextStyle(
                                      color: songsContainerTextColorAnimation
                                          .value,
                                    ),
                                  ),
                                  Text(
                                    "Mission Mangal, 2018",
                                    style: TextStyle(
                                      color: songsContainerTextColorAnimation
                                          .value,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: paneController,
      builder: (BuildContext context, widget) {
        return stackBody(context);
      },
    );
  }
}
