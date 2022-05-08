// Packages
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Player with ChangeNotifier {
  AudioPlayer player = AudioPlayer();

  Future<Duration?> setAsset(String assetPath) => player.setAsset(assetPath);

  void play() => player.play();

  void stop() => player.stop();
}
