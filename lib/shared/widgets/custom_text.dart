import 'package:flutter/widgets.dart';

/// A small, reusable text widget with convenient style overrides.
///
/// Use this throughout the app to keep typography consistent while allowing
/// quick per-use overrides for color, size, weight, and other text properties.
class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? letterSpacing;
  final TextDecoration? decoration;

  const CustomText(
    this.text, {
    super.key,
    this.style,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.letterSpacing,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style;
    final merged = base
        .merge(style)
        .copyWith(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: letterSpacing,
          decoration: decoration,
        );

    return Text(
      text,
      style: merged,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
