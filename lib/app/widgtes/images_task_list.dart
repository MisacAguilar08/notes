import 'package:flutter/material.dart';

class ImagesTaskList extends StatelessWidget {
  final String nameImages;
  final double imageWidth;
  final double imageHeight;

  const ImagesTaskList({required this.nameImages, super.key, this.imageWidth = 80, this.imageHeight = 80});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/$nameImages.png',
      width: imageWidth,
      height: imageHeight,
    );
  }
}
