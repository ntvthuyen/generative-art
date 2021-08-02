import 'package:flutter/widgets.dart';

// TOP, BOTTOM, RIGHT, LEFT, TOPRIGHT, BOTTOMRIGHT, TOPLEFT, BOTTOMLEFT
List<double> DIRECTION = [0, 0.785, 1.57, 2.355, 3.14, 3.925, 4.71, 5.495];

class Particle {
  Particle(this.dx, this.dy, this.radius, this.color, this.speed, this.theta,
      this.direction);
  late double dx;
  late double dy;
  final Color color;
  late double radius;
  late double speed;
  late double theta;
  late int direction;
}
