import 'package:flutter/widgets.dart';

// TOP, BOTTOM, RIGHT, LEFT, TOPRIGHT, BOTTOMRIGHT, TOPLEFT, BOTTOMLEFT

class RecParticle {
  RecParticle(this.dx, this.dy, this.color, this.width, this.height,
      this.edgesize, this.theta, this.radian, this.speed, this.direction);
  late double dx;
  late double dy;
  late double edgesize;
  final Color color;
  late double width;
  late double height;
  late double speed;
  late double theta;
  late double radian;
  late int direction;
}
