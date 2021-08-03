import 'dart:math';
import 'package:udp/udp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thesis/Animation/destroy_animation.dart';
import 'package:thesis/Particle/square_particle.dart';
import 'package:thesis/Painter/first_painter.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

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

  late int current_action = -1;
  static StreamController<int> streamController = new StreamController<int>();
  final int pallete = 0;
  late Animation<double> animation;
  late AnimationController controller;
  void t() async {
    streamController.add(-1);
    var receiver = await UDP.bind(Endpoint.loopback(port: Port(65000)));
    await receiver.listen((datagram) async {
      String str = String.fromCharCodes(datagram.data);
      streamController.add(int.parse(str));
    });
  }

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
    t();
  }

  void paintSky(Canvas canvas, Rect rect) {
    const RadialGradient gradient = RadialGradient(
      center: Alignment(0.7, -0.6), // near the top right
      radius: 0.2,
      colors: <Color>[
        Color(0xFFFFFF00), // yellow sun
        Color(0xFF0099FF), // blue sky
      ],
      stops: <double>[0.4, 1.0],
    );
    // rect is the area we are painting over
    final Paint paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);
  }

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
    return Scaffold(
        backgroundColor: Colors.blueGrey[100],
        body: StreamBuilder<int>(
            stream: streamController.stream, // _bids,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData && snapshot.data! != -1) {
                streamController.add(-1);
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
                else if (snapshot.data! == 8) {
                  particles.forEach((element) {
                    for (int i = 0; i <= 26; ++i)
                      dparticles.add(DestroyParticle(element.dx, element.dy,
                              element.color, element.radius)
                          .buildWidget());
                  });
                  particles.clear();
                }
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

class yield {}
