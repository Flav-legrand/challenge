import 'package:flutter/material.dart';
import 'view/screens/splash_screen.dart'; // Ajouter le chemin de splash_screen
import 'view/theme/color.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Application de Cours',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Afficher d'abord l'écran de démarrage
    );
  }
}
