import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class FidgetZone extends StatefulWidget {
  const FidgetZone({super.key});

  @override
  State<FidgetZone> createState() => _FidgetZoneState();
}

class _FidgetZoneState extends State<FidgetZone> {
  static const clickStart = "clickStart.mp3";
  static const clickEnd = "clickEnd.mp3";
  final audioPlayer = AudioPlayer();
  double circleSize = 150;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: GestureDetector(
            onTapDown: (details) {
              audioPlayer.play(AssetSource(clickStart));
              setState(() {
                circleSize = 125;
              });
            },
            onTapUp: (details) {
              audioPlayer.play(AssetSource(clickEnd));
              setState(() {
                circleSize = 100;
              });
            },
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(150),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }
}
