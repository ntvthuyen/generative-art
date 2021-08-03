import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:thesis/Screens/rotate_screen.dart';
import 'package:thesis/Screens/square_screen.dart';

void main() => runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(body: Center(child: Page()))));

class Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
          child: Text("Bubble!!"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SquareScreen()),
            );
          }),
      InkWell(
          child: Text("Rotationx2!!"),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => RotateScreen()),
            );
          })
    ]);
  }
}
