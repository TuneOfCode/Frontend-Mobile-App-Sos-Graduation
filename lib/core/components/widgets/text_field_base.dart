import 'package:flutter/material.dart';

class TextFieldBase extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isTypePassword;
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
    this.isTypePassword = false,
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
  State<TextFieldBase> createState() => _TextFieldBaseState();
}

class _TextFieldBaseState extends State<TextFieldBase> {
  late bool _isObscured;

  @override
  void initState() {
    _isObscured = widget.isTypePassword;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: widget.width,
          height: widget.height,
          child: TextField(
            obscureText: _isObscured,
            controller: widget.controller,
            textAlign: TextAlign.left,
            style: TextStyle(
              color: widget.textColor,
              fontSize: widget.fontSize,
              fontWeight: widget.fontWeight,
            ),
            decoration: InputDecoration(
              labelText: widget
                  .labelText, // controller.text.isEmpty ? labelText : null,
              labelStyle: TextStyle(
                color: widget.errorText.isEmpty ? widget.color : Colors.red,
                fontSize: widget.fontSize,
                fontWeight: widget.fontWeight,
              ),
              // errorText: errorText.isEmpty ? null : errorText,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: 1,
                  color: widget.errorText.isEmpty
                      ? widget.borderColor
                      : Colors.red,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                borderSide: BorderSide(
                  width: widget.borderWidth,
                  color: widget.errorText.isEmpty ? widget.color : Colors.red,
                ),
              ),
              suffixIcon: widget.isTypePassword
                  ? IconButton(
                      padding: const EdgeInsetsDirectional.only(end: 8),
                      icon: _isObscured
                          ? const Icon(
                              Icons.visibility,
                              color: Colors.black,
                              size: 20,
                            )
                          : const Icon(
                              Icons.visibility_off,
                              color: Colors.black,
                              size: 20,
                            ),
                      onPressed: () {
                        setState(() {
                          _isObscured = !_isObscured;
                        });
                      },
                    )
                  : null,
            ),
            onChanged: widget.onChanged,
          ),
        ),
        Text(widget.errorText,
            style: const TextStyle(color: Colors.red, fontSize: 12)),
      ],
    );
  }
}
