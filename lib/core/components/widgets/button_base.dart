import 'package:flutter/material.dart';

class ButtonBase extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  final double width;
  final double height;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final Color textColor;
  final double borderRadius;

  const ButtonBase({
    super.key,
    required this.text,
    this.onPressed,
    this.width = 300,
    this.height = 56,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w500,
    this.color = const Color(0xFF9F7BFF),
    this.textColor = Colors.white,
    this.borderRadius = 10,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      child: SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}
