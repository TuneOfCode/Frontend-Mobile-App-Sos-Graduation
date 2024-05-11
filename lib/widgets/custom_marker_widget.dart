import 'package:flutter/material.dart';

class CustomMarkerWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final Color? colorPin;

  const CustomMarkerWidget({
    super.key,
    required this.imageUrl,
    required this.title,
    this.colorPin = Colors.blueAccent,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Image.asset(
          'assets/images/marker.png',
          width: 45,
          height: 45,
          color: colorPin,
        ),
        Positioned(
          top: 12,
          child: CircleAvatar(
            radius: 12,
            backgroundImage: NetworkImage(
              imageUrl,
            ),
          ),
        ),
      ],
    );
  }
}
