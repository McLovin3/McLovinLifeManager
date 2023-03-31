import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:mclovin_life_manager/widgets/other/sound_button.dart';

class FidgetZone extends StatefulWidget {
  const FidgetZone({super.key});

  @override
  State<FidgetZone> createState() => _FidgetZoneState();
}

class _FidgetZoneState extends State<FidgetZone> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SoundButton(
                soundOnPress: "clickStart.mp3",
                soundOnRelease: "clickEnd.mp3",
                buttonColor: Colors.blue,
              ),
              SoundButton(
                soundOnPress: "clickStart.mp3",
                soundOnRelease: "clickEnd.mp3",
                buttonColor: Colors.red,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SoundButton(
                soundOnPress: "clickStart.mp3",
                soundOnRelease: "clickEnd.mp3",
                buttonColor: Colors.green,
              ),
              SoundButton(
                soundOnPress: "clickStart.mp3",
                soundOnRelease: "clickEnd.mp3",
                buttonColor: Colors.yellow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
