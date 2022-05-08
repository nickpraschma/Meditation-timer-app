// Packages
import 'package:flutter/material.dart';
import 'package:duration/duration.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

// Widgets
import '../widgets/begin_meditation_button.dart';
import '../widgets/timer_input_field.dart';

// Packages
import '../providers/home_screen_provider.dart';

// Models
import '../models/sound.dart';

// Data
import '../data/data.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Duration meditationDuration = const Duration(minutes: 15);
  // Sound? endingBell;
  // Sound? ambientSound;
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
    var provider = Provider.of<HomeScreenProvider>(context);
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
                rightText: prettyDuration(provider.meditationDuration),
                onTap: () =>
                    Provider.of<HomeScreenProvider>(context, listen: false)
                        .getDuration(context),
              ),
              const _TimerScreenDivider(),
              TimerInputField(
                leftText: "Ambient Sound",
                rightText: provider.ambientSound?.name ?? "None",
                onTap: _getAmbientSound,
              ),
              const _TimerScreenDivider(),
              TimerInputField(
                leftText: "Ending Bell",
                rightText: provider.endingBell?.name ?? "None",
                onTap: _getEndingBell,
              ),
              const _TimerScreenDivider(),
              const SizedBox(height: 30),
              const BeginMeditationButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _getEndingBell() async {
    var resultingBell = await getSound('Select Ending Bell', bells);
    Provider.of<HomeScreenProvider>(context, listen: false)
        .setEndingBell(resultingBell);
    // setState(() => endingBell = resultingBell);
  }

  void _getAmbientSound() async {
    var resultingSound = await getSound('Select Ambient Sound', ambientSounds);
    Provider.of<HomeScreenProvider>(context, listen: false)
        .setAmbientSound(resultingSound);
    // setState(() => ambientSound = resultingSound);
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
