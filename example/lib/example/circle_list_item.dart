import 'package:flutter/material.dart';

class CircleListItem extends StatelessWidget {
  final double size;

  const CircleListItem({Key key, this.size = 80}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
