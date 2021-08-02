import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:thesis/Particle/square_particle.dart';

// ignore: non_constant_identifier_names
Offset PolarToCartesian(double speed, double theta) {
  return Offset(speed * cos(theta), speed * sin(theta));
}

class MyPainterCanvas extends CustomPainter {
  MyPainterCanvas(
      this.particles, this.randomColor, this.maxspeed, this.anivalue);
  List<Particle> particles;
  double anivalue;
  double maxspeed;
  Random _random = Random(DateTime.now().millisecondsSinceEpoch);
  bool randomColor = true;
  @override
  void paint(Canvas canvas, Size size) {
    this.particles.forEach((element) {
      Offset v;
      double dx;
      double dy;
      if (element.direction >= 0) {
        v = PolarToCartesian(element.speed, DIRECTION[element.direction]) +
            PolarToCartesian(element.speed * 0.3, element.theta);
      } else {
        v = PolarToCartesian(element.speed, element.theta);
      }
      dx = element.dx + v.dx;
      dy = element.dy + v.dy;

      if (dy < 0) {
        element.direction = -1;
        element.speed = _random.nextDouble() * 1;
        element.theta = _random.nextDouble() * 6.28;
        dy = 0;
      } else if (dy > size.height) {
        element.direction = -1;
        element.speed = _random.nextDouble() * 1;
        element.theta = _random.nextDouble() * 6.28;
        dy = size.height;
      }
      if (dx < 0) {
        element.direction = -1;
        element.speed = _random.nextDouble() * 1;
        element.theta = _random.nextDouble() * 6.28;
        dx = 0;
      } else if (dx > size.width) {
        element.direction = -1;
        element.speed = _random.nextDouble() * 1;
        element.theta = _random.nextDouble() * 6.28;
        dx = size.width;
      }
      element.dx = dx;
      element.dy = dy;
      Offset offset = Offset(element.dx, element.dy);
      Paint _paint = Paint();

      _paint.color = element.color;
      canvas.drawCircle(offset, element.radius, _paint);
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
