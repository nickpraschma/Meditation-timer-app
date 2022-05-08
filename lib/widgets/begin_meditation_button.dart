// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import '../providers/home_screen_provider.dart';

// Screens
import '../screens/timer_screen.dart';

class BeginMeditationButton extends StatelessWidget {
  const BeginMeditationButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HomeScreenProvider>(context, listen: false);
    return InkWell(
      customBorder: const CircleBorder(),
      child: Container(
        height: 120,
        width: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.75),
        ),
        child: const Icon(
          Icons.play_arrow,
          color: Colors.black,
          size: 45,
        ),
      ),
      onTap: () => Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (c, a1, a2) => TimerScreen(
            meditationDuration: provider.meditationDuration,
            endingBell: provider.endingBell,
            ambientSound: provider.ambientSound,
          ),
          transitionsBuilder: (_, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
