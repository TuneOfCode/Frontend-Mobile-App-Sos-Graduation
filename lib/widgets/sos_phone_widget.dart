import 'package:flutter/material.dart';
import 'package:sos_app/widgets/sos_countdown_time_widget.dart';

class SosPhoneWidget extends StatelessWidget {
  const SosPhoneWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(1.0),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 3.0,
                color: Colors.red,
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
            height: 80,
            width: 80,
            child: IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SosCountdownTimeWidget(),
                  ),
                );
              },
              icon: const Icon(
                Icons.phone_in_talk_sharp,
                size: 55,
                color: Colors.red,
              ),
            ),
          ),
          const Text(
            'SOS',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
