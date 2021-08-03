import 'dart:math';
import 'package:thesis/Painter/second_painter.dart';
import 'package:thesis/Particle/rectangle_particle.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:udp/udp.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thesis/Animation/destroy_animation.dart';
import 'package:thesis/Particle/square_particle.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class RotateScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => RotateScreenState();
}

class RotateScreenState extends State<RotateScreen>
    with SingleTickerProviderStateMixin {
  late List<RecParticle> particles = <RecParticle>[];
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

  void rotate() {
    particles.forEach((element) {
      element.radian += element.speed;
    });
  }

  void zoomIn() {
    particles.forEach((element) {
      element.width += 12;
      element.height += 12;
    });
  }

  void zoomOut() {
    if (particles[0].width >= 15)
      particles.forEach((element) {
        element.width -= 12;
        element.height -= 12;
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
    int n = 40;
    for (int i = 0; i < n; ++i) {
      particles.add(new RecParticle(0, 0, colors[1][3 + i % 4], i * 20 + 20,
          i * 20 + 20, 1, 3.14, 3.14 / 180 * i, 0.001 * (n - i), -1));
    }
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
    rotate();
    return Scaffold(
        floatingActionButton: Column(children: []),
        backgroundColor: Colors.blueGrey[100],
        body: StreamBuilder<int>(
            stream: streamController.stream, // _bids,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData && snapshot.data! != -1) {
                streamController.add(-1);
                if (snapshot.data! == 10) {
                  particles.asMap().forEach((index, element) {
                    element.speed = -0.001 * (particles.length - index);
                  });
                } else if (snapshot.data! == 11) {
                  particles.asMap().forEach((index, element) {
                    element.speed = 0.001 * (particles.length - index);
                  });
                } else if (snapshot.data! == 12) {
                  zoomIn();
                } else if (snapshot.data! == 13) {
                  zoomOut();
                }
              }

              return CustomPaint(
                size: Size.infinite,
                painter: SecondPainterCanvas(particles),
              );
            }));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
