import 'dart:math';
import 'dart:ui';
import 'package:flutter/widgets.dart';
import 'package:thesis/Particle/rectangle_particle.dart';

// ignore: non_constant_identifier_names
Offset PolarToCartesian(double speed, double theta) {
  return Offset(speed * cos(theta), speed * sin(theta));
}

class SecondPainterCanvas extends CustomPainter {
  SecondPainterCanvas(this.rects);
  Random _random = Random(DateTime.now().millisecondsSinceEpoch);
  bool randomColor = true;
  List<RecParticle> rects;
  @override
  void paint(Canvas canvas, Size size) {
    Offset offset = Offset(size.width / 2, size.height / 2);
    rects.forEach((element) {
      Paint _paint = Paint();
      _paint.style = PaintingStyle.stroke;
      _paint.strokeWidth = 10;
      _paint.color = element.color;
      Rect rect = new Rect.fromCenter(
          center: Offset(element.dx, element.dy),
          width: element.width,
          height: element.height);
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(element.radian);
      canvas.drawRect(rect, _paint);
      canvas.restore();
    });
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
