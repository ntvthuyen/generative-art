import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AniProps {
  x,
  y,
  scale,
}

// ignore: must_be_immutable
class DestroyParticle {
  DestroyParticle(this.x, this.y, this.color, this.radius);
  final double x;
  final double y;
  late Random random = Random();
  final Color color;
  final double radius;
  late TimelineTween<AniProps> _tween = TimelineTween<AniProps>()
    ..addScene(begin: 0.seconds, duration: 2.0.seconds).animate(AniProps.x,
        tween: (this.x).tweenTo(this.x +
            (350) * random.nextDouble() * (random.nextBool() ? 1 : -1)))
    ..addScene(begin: 0.seconds, duration: 2.0.seconds).animate(AniProps.y,
        tween: (this.y).tweenTo(this.y +
            (350) * random.nextDouble() * (random.nextBool() ? 1 : -1)))
    ..addScene(begin: 0.seconds, end: 2.0.seconds)
        .animate(AniProps.scale, tween: 2.0.tweenTo(0));

  buildWidget() {
    return PlayAnimation<TimelineValue<AniProps>>(
        tween: _tween, // Pass in tween
        duration: _tween.duration, // Obtain duration
        builder: (context, child, value) {
          return Transform.translate(
            // Get animated offset
            offset: Offset(value.get(AniProps.x), value.get(AniProps.y)),
            child: Transform.scale(
                scale: value.get(AniProps.scale),
                child: Container(
                  width: radius,
                  height: radius,
                  color: color,
                )),
          );
        });
  }
}
