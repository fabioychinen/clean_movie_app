import 'package:flutter/material.dart';

class FixedLineText extends StatelessWidget {
  static const lineHeightFactor = 1.3;

  final String text;
  final double fontSize;
  final int maxLines;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign textAlign;

  const FixedLineText(
    this.text, {
    super.key,
    required this.fontSize,
    required this.maxLines,
    this.fontWeight,
    this.color,
    this.textAlign = TextAlign.center,
  });

  static double heightOf(
    BuildContext context, {
    required double fontSize,
    required int lines,
  }) {
    final scaledFontSize = MediaQuery.textScalerOf(context).scale(fontSize);
    return (scaledFontSize * lineHeightFactor * lines).ceilToDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: lineHeightFactor,
      ),
      strutStyle: StrutStyle(
        fontSize: fontSize,
        height: lineHeightFactor,
        forceStrutHeight: true,
      ),
    );
  }
}