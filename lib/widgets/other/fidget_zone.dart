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
          Expanded(
            child: SleekCircularSlider(
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
              initialValue: 50,
              onChange: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
