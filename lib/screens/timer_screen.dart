// Packages
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// Models
import '../models/sound.dart';

// Widgets
import '../widgets/countdown_timer.dart';

class TimerScreen extends StatefulWidget {
  final Duration meditationDuration;
  final Sound? endingBell;
  final Sound? ambientSound;

  const TimerScreen({
    Key? key,
    required this.meditationDuration,
    required this.endingBell,
    required this.ambientSound,
  }) : super(key: key);

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  late AudioPlayer player;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      player = AudioPlayer();
    });
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 20, 18, 20),
            Color.fromARGB(255, 38, 36, 39),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: CountDownTimer(duration: widget.meditationDuration),
            ),
          ],
        ),
      ),
    );
  }
}
