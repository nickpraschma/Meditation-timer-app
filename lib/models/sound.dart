class Sound {
  final String name;
  late final String imageUrl;
  late final String soundUrl;

  // Bell({
  //   required this.name,
  //   required this.imageUrl,
  //   required this.soundUrl,
  // });

  Sound(
      {required this.name,
      required String imageUrl,
      required String soundUrl}) {
    this.imageUrl = 'assets/images/' + imageUrl;
    this.soundUrl = 'assets/audio/' + soundUrl;
  }
}
