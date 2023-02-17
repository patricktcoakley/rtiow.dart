import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:rtiow/vector3.dart';

class Canvas {
  final int imageWidth;
  final int imageHeight;
  final double aspectRatio;
  final int samplesPerPixel;

  late final double _pixelScale = 1.0 / samplesPerPixel;
  late final img.Image _image =
      img.Image(height: imageHeight, width: imageWidth);

  Canvas(
      {this.imageWidth = 400,
      int? imageHeight,
      this.aspectRatio = 16.0 / 9.0,
      this.samplesPerPixel = 100})
      : imageHeight = imageHeight ?? imageWidth ~/ aspectRatio;

  void writeColor(Color color, int x, int y) {
    var ir = (255 * (sqrt(_pixelScale * color.r).clamp(0.0, 0.999))).toInt();
    var ig = (255 * (sqrt(_pixelScale * color.g).clamp(0.0, 0.999))).toInt();
    var ib = (255 * (sqrt(_pixelScale * color.b).clamp(0.0, 0.999))).toInt();
    _image.setPixelRgb(x, y, ir, ig, ib);
  }

  void writeImage() async {
    final png = img.encodePng(_image);
    await File('out.png').writeAsBytes(png);
  }
}
