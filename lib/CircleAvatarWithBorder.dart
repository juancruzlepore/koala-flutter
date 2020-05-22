import 'package:flutter/material.dart';

class CircleAvatarWithBorder extends StatelessWidget {
  final String backgroundImage;
  final double radius;
  final int borderWidth;
  final Color backgroundColor;

  CircleAvatarWithBorder({this.backgroundImage, this.radius,
      this.backgroundColor, this.borderWidth = 5 });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        backgroundColor: this.backgroundColor,
        radius: this.radius,
        child: CircleAvatar(
          backgroundImage: AssetImage(backgroundImage),
          radius: this.radius - this.borderWidth,
        )
    );
  }
}