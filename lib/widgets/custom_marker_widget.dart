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
          width: 60,
          height: 60,
          color: colorPin,
        ),
        Positioned(
          top: 7.5,
          child: CircleAvatar(
            radius: 16,
            backgroundImage: NetworkImage(
              imageUrl,
            ),
          ),
        ),
      ],
    );
  }
}
