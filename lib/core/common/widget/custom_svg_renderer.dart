import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MySvgRenderer extends CustomPainter{
  final DrawableRoot svgString;

   MySvgRenderer(this.svgString){
    shouldRepaint(this);
  }
  @override
  void paint(Canvas canvas, Size size) {
    svgString?.scaleCanvasToViewBox(canvas,const Size(18, 15));
    svgString?.draw(canvas, Rect.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

}