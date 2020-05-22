import 'package:flutter/material.dart';

import 'CircleAvatarWithBorder.dart';

class Person {
  final String name;
  final String imagePath;
  final Color accentColor;

  static const Person Anne =
      Person('Anne', 'assets/images/anne.jpg', Colors.pink);
  static const Person Juan =
      Person('Juan', 'assets/images/juan.jpg', Colors.blueAccent);

  const Person(this.name, this.imagePath, this.accentColor);

  CircleAvatarWithBorder getAvatar(double radius, {int borderWidth = 2}) {
    return CircleAvatarWithBorder(
      backgroundImage: this.imagePath,
      radius: radius,
      backgroundColor: this.accentColor,
      borderWidth: borderWidth,
    );
  }

  static Person fromName(String name) {
    switch (name.toLowerCase()) {
      case 'anne':
        return Anne;
      case 'juan':
        return Juan;
    }
    return null;
  }
}
