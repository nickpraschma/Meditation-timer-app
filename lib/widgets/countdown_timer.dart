/* Source: https://medium.flutterdevs.com/creating-a-countdown-timer-using-animation-in-flutter-2d56d4f3f5f1
*/

// Packages
import 'package:flutter/material.dart';

class CountDownTimer extends StatefulWidget {
  final Duration duration;
  const CountDownTimer({
    Key? key,
    required this.duration,
  }) : super(key: key);

  @override
  _CountDownTimerState createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  String get timerString {
    Duration time = controller.duration! * controller.value == Duration.zero
        ? widget.duration
        : controller.duration! * controller.value;
    return '${time.inMinutes}:${(time.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: widget.duration + const Duration(milliseconds: 999),
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller.reverse(
          from: controller.value == 0.0 ? 1.0 : controller.value);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                timerString,
                style: TextStyle(
                  fontSize: 100.0,
                  color: Colors.white.withOpacity(0.85),
                ),
              ),
              AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return FloatingActionButton.extended(
                    elevation: 0,
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      if (controller.isAnimating) {
                        setState(() => controller.stop());
                      } else {
                        controller.reverse(
                            from: controller.value == 0.0
                                ? 1.0
                                : controller.value);
                      }
                    },
                    icon: Icon(controller.isAnimating
                        ? Icons.pause
                        : Icons.play_arrow),
                    label: Text(controller.isAnimating ? "Pause" : "Play"),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
