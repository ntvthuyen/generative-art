import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:thesis/Screens/square_screen.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LoopAnimation<double>(
        tween: 0.0.tweenTo(10.0),
        duration: 2.seconds,
        curve: Curves.easeOut,
        builder: (context, child, value) {
          return Transform.scale(
            scale: value,
            child: child,
          );
        },
        child: InkWell(
            child: Text("CLAP to go!!"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SquareScreen()),
              );
            }));
  }
}
