// Packages
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';

// Models
import '../models/sound.dart';

class HomeScreenProvider extends ChangeNotifier {
  Duration _meditationDuration = const Duration(minutes: 15);
  Sound? _endingBell;
  Sound? _ambientSound;

  Duration get meditationDuration => _meditationDuration;
  Sound? get endingBell => _endingBell;
  Sound? get ambientSound => _ambientSound;

  void getDuration(BuildContext context) async {
    var resultingDuration = await showDurationPicker(
      context: context,
      initialTime: meditationDuration,
    );
    _meditationDuration = resultingDuration!;
    notifyListeners();
  }

  void setEndingBell(Sound? endingBell) {
    _endingBell = endingBell;
    notifyListeners();
  }

  void setAmbientSound(Sound? ambientSound) {
    _ambientSound = ambientSound;
    notifyListeners();
  }
}
