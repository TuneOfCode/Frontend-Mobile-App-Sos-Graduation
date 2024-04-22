import 'package:flutter/material.dart';

class TextFieldBase extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final double width;
  final String errorText;
  final double height;
  final Color textColor;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final double borderWidth;
  final Color borderColor;
  final Function(String)? onChanged;

  const TextFieldBase({
    super.key,
    required this.controller,
    required this.labelText,
    this.width = double.infinity,
    this.errorText = "",
    this.height = 56,
    this.textColor = const Color(0xFF393939),
    this.color = const Color(0xFF755DC1),
    this.fontSize = 15,
    this.fontWeight = FontWeight.w600,
    this.borderWidth = 1,
    this.borderColor = const Color(0xFF837E93),
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: width,
          height: height,
          child: TextField(
            controller: controller,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            decoration: InputDecoration(
              labelText:
                  labelText, // controller.text.isEmpty ? labelText : null,
              labelStyle: TextStyle(
                color: errorText.isEmpty ? color : Colors.red,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
              // errorText: errorText.isEmpty ? null : errorText,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: errorText.isEmpty ? borderColor : Colors.red,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: borderWidth,
                  color: errorText.isEmpty ? color : Colors.red,
                ),
              ),
            ),
            onChanged: onChanged,
          ),
        ),
        Text(errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12)),
      ],
    );
  }
}
