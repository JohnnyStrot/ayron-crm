import 'package:flutter/material.dart';

class RoundedImageIcon extends StatelessWidget {
  /// Location in image-data folder.
  final String imageLocation;
  final double size;

  final String _baseImageUrl = String.fromEnvironment(
    'base_image_url',
    defaultValue: 'http://localhost:4006/image-data',
  );

  RoundedImageIcon({
    super.key,
    required this.imageLocation,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Align(
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.all(Radius.circular(8.0)),
          child: Image.network("$_baseImageUrl/$imageLocation"),
        ),
      ),
    );
  }
}
