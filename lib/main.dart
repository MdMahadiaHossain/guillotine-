import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        top: false,
        bottom: true,
        child: Container(
          child: Stack(
            alignment: Alignment.topLeft,
            children: <Widget>[
              Page(),
              GilatonMenu(),
            ],
          ),
        ),
      ),
    );
  }
}

class Page extends StatefulWidget {
  @override
  _PageState createState() => _PageState();
}

class _PageState extends State<Page> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GilatonMenu extends StatefulWidget {
  @override
  _GilatonMenuState createState() => _GilatonMenuState();
}

class _GilatonMenuState extends State<GilatonMenu>
    with SingleTickerProviderStateMixin {
  double rotationAngle = (pi / 2);

  AnimationController animationControllerMenu;
  Animation<double> animationMenu;
  CommonAnimationStatus commonAnimationStatus;

  @override
  void initState() {
    super.initState();
    animationControllerMenu = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        switch (status) {

          /// When the animation is at the end, the menu is open
          case AnimationStatus.completed:
            commonAnimationStatus = CommonAnimationStatus.open;
            break;

          /// When the animation is at the beginning, the menu is closed
          case AnimationStatus.dismissed:
            commonAnimationStatus = CommonAnimationStatus.close;
            break;
          case AnimationStatus.forward:
            commonAnimationStatus = CommonAnimationStatus.opening;
            break;
          case AnimationStatus.reverse:
            commonAnimationStatus = CommonAnimationStatus.closing;
        }
      });

    animationMenu = Tween(
      begin: -pi / 2.0,
      end: 0.0,
    ).animate(animationControllerMenu);
  }

  @override
  void dispose() {
    animationControllerMenu.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// to obtain the size of the current window of BuildContext, use `MediaQuery.of(context).size`.
    /// note: build is the top parent context
    MediaQueryData mediaQueryData = MediaQuery.of(context);

    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;

    return Material(

        /// if we use Transform() object we would use Matrix4 in transform property of the Transform() object
        child: Transform.rotate(
      /// in flutter 0 degree starts at left side and 180 degree ends in right-side
      angle: animationMenu.value,

      ///set the center  point of rotation
      origin: Offset(24.0, 56.0),

      ///sets  x axis and y  axis of center if pi changes
      alignment: Alignment.topLeft,
      child: Container(
        color: Colors.green,
        height: screenHeight,
        width: screenWidth,
        child: Stack(
          children: <Widget>[
            menuIcon(context),
          ],
        ),
      ),
    ));
  }

  Widget menuIcon(BuildContext context) {
    return Positioned(
      child: Material(
        color: Colors.transparent,
        child: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white,
            size: 40.0,
          ),
          onPressed: () {
           _toggleAction();
          },
        ),
      ),
      top: 30.0, // distance from top
      left: 00.0, //distance from left
    );
  }

  void _toggleAction() {
   if(commonAnimationStatus == CommonAnimationStatus.close || commonAnimationStatus == null){
     animationControllerMenu.forward();
   } else if (commonAnimationStatus == CommonAnimationStatus.open){
     animationControllerMenu.reverse();
   }

  }
}

enum CommonAnimationStatus {
  open,
  close,
  opening,
  closing,
}


