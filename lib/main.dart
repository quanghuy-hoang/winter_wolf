import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winter_wolf/models/painting.dart';

import 'screens/drawing_app_main_screen.dart';
import 'models/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffff8484)),
        scaffoldBackgroundColor: const Color(0xFFFFE9E9),
        useMaterial3: true,
      ),
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => SettingsProvider()),
          ChangeNotifierProvider(create: (context) => PaintingProvider())
        ],
        child: const DrawingAppMainScreen(),
      ),
    );
  }
}
