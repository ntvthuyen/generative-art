import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thesis/Animation/destroy_animation.dart';
import 'package:thesis/Particle/square_particle.dart';
import 'package:thesis/painter.dart';
import 'package:audioplayers/audioplayers.dart';

class SquareScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SquareScreenState();
}

class SquareScreenState extends State<SquareScreen>
    with SingleTickerProviderStateMixin {
  late List<Particle> particles = <Particle>[];
  late List<Widget> dparticles = <Widget>[];
  static int MAXADD = 65;
  static int MINRADIUS = 20;
  final _random = new Random(DateTime.now().microsecondsSinceEpoch);

  final int pallete = 0;
  late Animation<double> animation;
  late AnimationController controller;
  final AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
  /*Future<int> playLocalAsset(String name) async {
    return await audioPlayer.play(name, isLocal: true);
  }*/
  Stream<int> _bids = (() async* {
    Random _random = new Random(DateTime.now().microsecondsSinceEpoch);
    while (true) {
      await Future<void>.delayed(const Duration(seconds: 2));
      var a = _random.nextInt(10);
      yield a;
      await Future<void>.delayed(const Duration(milliseconds: 100));

      yield -1;
      await Future<void>.delayed(const Duration(seconds: 2));
    }
  })();

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 2), vsync: this);
    animation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {
          // The state that has changed here is the animation object’s value.
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }
  /*
    $light-pink: rgba(255, 173, 173, 1);
    $deep-champagne: rgba(255, 214, 165, 1);
    $lemon-yellow-crayola: rgba(253, 255, 182, 1);
    $tea-green: rgba(202, 255, 191, 1);
    $celeste: rgba(155, 246, 255, 1);
    $baby-blue-eyes: rgba(160, 196, 255, 1);
    $maximum-blue-purple: rgba(189, 178, 255, 1);
    $mauve: rgba(255, 198, 255, 1);
    $baby-powder: rgba(255, 255, 252, 1);
   */

  /*
    $red-salsa: rgba(249, 65, 68, 1);
    $orange-red: rgba(243, 114, 44, 1);
    $yellow-orange-color-wheel: rgba(248, 150, 30, 1);
    $mango-tango: rgba(249, 132, 74, 1);
    $maize-crayola: rgba(249, 199, 79, 1);
    $pistachio: rgba(144, 190, 109, 1);
    $zomp: rgba(67, 170, 139, 1);
    $cadet-blue: rgba(77, 144, 142, 1);
    $queen-blue: rgba(87, 117, 144, 1);
    $cg-blue: rgba(39, 125, 161, 1);
  */
  List<List<Color>> colors = [
    [
      Color.fromRGBO(255, 173, 173, 1),
      Color.fromRGBO(255, 214, 165, 1),
      Color.fromRGBO(253, 255, 182, 1),
      Color.fromRGBO(202, 255, 191, 1),
      Color.fromRGBO(155, 246, 255, 1),
      Color.fromRGBO(160, 196, 255, 1),
      Color.fromRGBO(189, 178, 255, 1),
      Color.fromRGBO(255, 198, 255, 1),
      Color.fromRGBO(255, 255, 252, 1),
    ],
    [
      Color.fromRGBO(249, 65, 68, 1),
      Color.fromRGBO(243, 114, 44, 1),
      Color.fromRGBO(248, 150, 30, 1),
      Color.fromRGBO(249, 132, 74, 1),
      Color.fromRGBO(249, 199, 79, 1),
      Color.fromRGBO(144, 190, 109, 1),
      Color.fromRGBO(67, 170, 139, 1),
      Color.fromRGBO(77, 144, 142, 1),
      Color.fromRGBO(87, 117, 144, 1),
      Color.fromRGBO(39, 125, 161, 1)
    ]
  ];
  @override
  Widget build(BuildContext context) {
    Paint paint = Paint();
    paint.color = Colors.red;
    return Scaffold(
        floatingActionButton: Column(
          children: [
            IconButton(
                onPressed: () {
                  dparticles.clear();
                  if (particles.length <= 50) {
                    //playLocalAsset("audio/drop_004.mp3");
                    int RADIUS =
                        MINRADIUS + (_random.nextDouble() * MAXADD).toInt();
                    particles.add(Particle(
                        _random
                            .nextInt(MediaQuery.of(context).size.width.toInt() -
                                RADIUS)
                            .toDouble(),
                        _random
                            .nextInt(
                                MediaQuery.of(context).size.height.toInt() -
                                    RADIUS)
                            .toDouble(),
                        RADIUS.toDouble(),
                        colors[pallete]
                            [_random.nextInt(colors[pallete].length)],
                        _random.nextDouble() * 1,
                        _random.nextDouble() * 6.28,
                        -1));
                  }
                },
                icon: Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    for (int i = 0; i <= 26; ++i)
                      dparticles.add(DestroyParticle(element.dx, element.dy,
                              element.color, element.radius)
                          .buildWidget());
                  });
                  particles.clear();
                },
                icon: Icon(Icons.remove)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 6;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_upward)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 2;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_downward)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 4;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_left)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 0;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_right)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 7;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_upward)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 5;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_downward)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 3;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_left)),
            IconButton(
                onPressed: () {
                  particles.forEach((element) {
                    element.direction = 1;
                    element.speed = 3;
                  });
                },
                icon: Icon(Icons.arrow_right)),
          ],
        ),
        backgroundColor: Colors.blueGrey[100],
        body: StreamBuilder<int>(
            stream: _bids,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData && snapshot.data! != -1) {
                print(snapshot.data!);
                if (snapshot.data! == 9) {
                  dparticles.clear();
                  if (particles.length <= 50) {
                    //playLocalAsset("audio/drop_004.mp3");
                    int RADIUS =
                        MINRADIUS + (_random.nextDouble() * MAXADD).toInt();
                    particles.add(Particle(
                        _random
                            .nextInt(MediaQuery.of(context).size.width.toInt() -
                                RADIUS)
                            .toDouble(),
                        _random
                            .nextInt(
                                MediaQuery.of(context).size.height.toInt() -
                                    RADIUS)
                            .toDouble(),
                        RADIUS.toDouble(),
                        colors[pallete]
                            [_random.nextInt(colors[pallete].length)],
                        _random.nextDouble() * 1,
                        _random.nextDouble() * 6.28,
                        -1));
                  }
                } else if (snapshot.data! >= 0 && snapshot.data! < 8)
                  particles.forEach((element) {
                    element.direction = snapshot.data!;
                    element.speed = 3;
                  });
              }
              return CustomPaint(
                size: Size.infinite,
                painter: MyPainterCanvas(particles, true, 1, animation.value),
                child: Stack(children: dparticles),
              );
            }));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
