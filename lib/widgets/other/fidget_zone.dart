import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

import 'sound_button.dart';

class FidgetZone extends StatefulWidget {
  const FidgetZone({super.key});

  @override
  State<FidgetZone> createState() => _FidgetZoneState();
}

class _FidgetZoneState extends State<FidgetZone> {
  // ignore: unused_field
  double _sliderValue = 0;
  final audioplayer = AudioPlayer();
  final clickRate = 5;

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
                key: Key("Button1"),
                soundOnPress: "clickStart1.mp3",
                soundOnRelease: "clickEnd1.mp3",
                buttonColor: Colors.blue,
              ),
              SoundButton(
                key: Key("Button2"),
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
                key: Key("Button3"),
                soundOnPress: "clickStart3.mp3",
                soundOnRelease: "clickEnd3.mp3",
                buttonColor: Colors.green,
              ),
              SoundButton(
                key: Key("Button4"),
                soundOnPress: "clickStart4.mp3",
                soundOnRelease: "clickEnd4.mp3",
                buttonColor: Colors.yellow,
              ),
            ],
          ),
          Expanded(
            child: SleekCircularSlider(
              key: const Key("Slider"),
              appearance: CircularSliderAppearance(
                infoProperties: InfoProperties(
                  mainLabelStyle: const TextStyle(color: Colors.white),
                ),
                size: 300,
                angleRange: 360,
                customColors: CustomSliderColors(
                  progressBarColor: Colors.blue,
                  trackColor: Colors.blue,
                  dotColor: Colors.pink,
                ),
                customWidths: CustomSliderWidths(
                  shadowWidth: 0,
                  handlerSize: 30,
                  progressBarWidth: 20,
                  trackWidth: 20,
                ),
              ),
              onChange: (double value) {
                setState(() {
                  if (_sliderValue.round() % clickRate == 0) {
                    audioplayer.play(AssetSource("click.mp3"));
                  }
                  _sliderValue = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    audioplayer.dispose();
    super.dispose();
  }
}
