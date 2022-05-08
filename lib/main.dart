// Packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/audio_player_provider.dart';

// Screens
import 'screens/home_screen.dart';
import 'screens/timer_screen.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (ctx) => Player()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meditation Timer App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(
            fontSize: 30.0,
            fontWeight: FontWeight.bold,
            color: Colors.white.withOpacity(0.75),
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (ctx) => const HomeScreen(),
      },
    );
  }
}
