import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final IconData icon;
  final double size;

  const AvatarWidget({required this.icon, this.size = 50.0});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.white,
      child: Icon(icon, color: Colors.green, size: size),
    );
  }
}
