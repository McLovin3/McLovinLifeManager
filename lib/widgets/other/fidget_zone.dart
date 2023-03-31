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
                soundOnPress: "clickStart1.mp3",
                soundOnRelease: "clickEnd1.mp3",
                buttonColor: Colors.blue,
              ),
              SoundButton(
                soundOnPress: "clickStart2.mp3",
                soundOnRelease: "clickEnd2.mp3",
                buttonColor: Colors.red,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              SoundButton(
                soundOnPress: "clickStart3.mp3",
                soundOnRelease: "clickEnd3.mp3",
                buttonColor: Colors.green,
              ),
              SoundButton(
                soundOnPress: "clickStart4.mp3",
                soundOnRelease: "clickEnd4.mp3",
                buttonColor: Colors.yellow,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
