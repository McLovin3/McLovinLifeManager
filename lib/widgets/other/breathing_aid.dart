import 'package:flutter/material.dart';
import 'package:quiver/async.dart';

class BreathingAid extends StatefulWidget {
  const BreathingAid({super.key});

  @override
  State<BreathingAid> createState() => _BreathingAidState();
}

class _BreathingAidState extends State<BreathingAid>
    with TickerProviderStateMixin {
  final int breathingTime = 60;
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 4),
    vsync: this,
  );
  CountdownTimer? _countdownTimer;
  bool _isRunning = false;
  late int timer = breathingTime;

  void start() {
    setState(() {
      _controller.repeat(reverse: true);
      _countdownTimer = CountdownTimer(
        Duration(seconds: breathingTime),
        const Duration(seconds: 1),
      )..listen(
          (event) {
            setState(() {
              timer--;
            });
          },
          onDone: () {
            timer = breathingTime;
            _isRunning = false;
            _controller.stop();
          },
        );
      timer = breathingTime;
      _isRunning = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(150),
                ),
              ),
              Center(
                child: AnimatedBuilder(
                  animation: _controller,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.blue[400],
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 1 - _controller.value,
                      child: child,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Text(
              timer.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isRunning ? null : start,
          style: ButtonStyle(
            minimumSize: WidgetStateProperty.all(
              const Size(200, 50),
            ),
          ),
          child: const Text("Start"),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}
