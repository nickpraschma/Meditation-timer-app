// Packages
import 'package:flutter/material.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:duration/duration.dart';
import 'package:meditation_app/screens/timer_screen.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/timer_input_field.dart';

// Providers
import '../providers/audio_player_provider.dart';

// Models
import '../models/sound.dart';

// Data
import '../data/data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Duration meditationDuration = const Duration(minutes: 15);
  Sound? endingBell;
  Sound? ambientSound;
  late Player player;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      player = Provider.of<Player>(context, listen: false);
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
          title: Center(
            child: Text(
              'Meditation Timer',
              style: Theme.of(context).textTheme.headline1,
            ),
          ),
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              Container(
                height: 250,
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/rainbow_meditation.png'),
                )),
              ),
              const _TimerScreenDivider(),
              TimerInputField(
                leftText: "DURATION",
                rightText: prettyDuration(meditationDuration),
                onTap: _getDuration,
              ),
              const _TimerScreenDivider(),
              TimerInputField(
                leftText: "Ambient Sound",
                rightText: ambientSound?.name ?? "None",
                onTap: _getAmbientSound,
              ),
              const _TimerScreenDivider(),
              TimerInputField(
                leftText: "Ending Bell",
                rightText: endingBell?.name ?? "None",
                onTap: _getEndingBell,
              ),
              const _TimerScreenDivider(),
              const SizedBox(height: 30),
              _BeginMeditationButton(
                meditationDuration: meditationDuration,
                endingBell: endingBell,
                ambientSound: ambientSound,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getDuration() async {
    var resultingDuration = await showDurationPicker(
      context: context,
      initialTime: meditationDuration,
    );
    setState(() => meditationDuration = resultingDuration!);
  }

  void _getEndingBell() async {
    var resultingBell = await getSound('Select Ending Bell', bells);
    setState(() => endingBell = resultingBell);
  }

  void _getAmbientSound() async {
    var resultingSound = await getSound('Select Ambient Sound', ambientSounds);
    setState(() => ambientSound = resultingSound);
  }

  Future<Sound?> getSound(String title, List<Sound> sounds) async {
    Sound? returnSound;

    returnSound = await showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
          ),
          elevation: 16,
          child: SizedBox(
            height: 500,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          player.stop();
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: sounds.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 20,
                    ),
                    shrinkWrap: true,
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: GestureDetector(
                          onTap: () async {
                            // play bell sound
                            await player.setAsset(sounds[index].soundUrl);
                            player.play();
                            returnSound = sounds[index];
                          },
                          child: Image.asset(
                            sounds[index].imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                OutlinedButton(
                  child: const Text(
                    'Select',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    // select bell
                    Navigator.pop(context, returnSound);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
    player.stop();
    return returnSound;
  }
}

class _TimerScreenDivider extends StatelessWidget {
  const _TimerScreenDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.grey[600],
      thickness: 1,
    );
  }
}

class _BeginMeditationButton extends StatelessWidget {
  final Duration meditationDuration;
  final Sound? endingBell;
  final Sound? ambientSound;

  const _BeginMeditationButton({
    Key? key,
    required this.meditationDuration,
    required this.endingBell,
    required this.ambientSound,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            meditationDuration: meditationDuration,
            endingBell: endingBell,
            ambientSound: ambientSound,
          ),
          transitionsBuilder: (_, anim, a2, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 500),
        ),
      ),
    );
  }
}
