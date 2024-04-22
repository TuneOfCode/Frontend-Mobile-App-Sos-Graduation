import 'package:flutter/material.dart';

class IconButtonWidget extends StatelessWidget {
  final double? top;
  final double? right;
  final double? bottom;
  final double? left;
  final Color? boxColor;
  final Color? iconColor;
  final IconData? icon;
  final double? size;
  final void Function() onPressed;

  const IconButtonWidget({
    super.key,
    required this.onPressed,
    this.top,
    this.right,
    this.bottom,
    this.left,
    this.boxColor = Colors.red,
    this.iconColor = Colors.red,
    this.icon,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        margin: const EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            width: 3.0,
            color: boxColor!,
          ),
          borderRadius: const BorderRadius.all(
            Radius.circular(
              50,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        height: 60,
        width: 60,
        child: IconButton(
          onPressed: onPressed,
          icon: Icon(
            icon,
            size: size,
            color: iconColor,
          ),
        ),
      ),
    );
  }
}
