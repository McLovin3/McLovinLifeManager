import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class SoundButton extends StatefulWidget {
  final String soundOnPress;
  final String soundOnRelease;
  final Color buttonColor;

  const SoundButton({
    required this.soundOnPress,
    required this.soundOnRelease,
    required this.buttonColor,
    super.key,
  });

  @override
  State<SoundButton> createState() => _SoundButtonState();
}

class _SoundButtonState extends State<SoundButton> {
  final onTapDownPlayer = AudioPlayer();
  final onTapUpPlayer = AudioPlayer();
  double circleSize = 125;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Center(
        child: GestureDetector(
          onTapDown: (details) {
            onTapDownPlayer.play(AssetSource(widget.soundOnPress));
            setState(() {
              circleSize = 150;
            });
          },
          onTapUp: (details) {
            onTapUpPlayer.play(AssetSource(widget.soundOnRelease));
            setState(() {
              circleSize = 125;
            });
          },
          onTapCancel: () {
            onTapUpPlayer.play(AssetSource(widget.soundOnRelease));
            setState(() {
              circleSize = 125;
            });
          },
          child: Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              color: widget.buttonColor,
              borderRadius: BorderRadius.circular(150),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    onTapDownPlayer.dispose();
    onTapUpPlayer.dispose();
    super.dispose();
  }
}
