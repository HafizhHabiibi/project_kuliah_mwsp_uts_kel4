import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/screen/getstarted_screen.dart';

void main() {
  runApp(const BijiApp());
}

class BijiApp extends StatelessWidget {
  const BijiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biji Coffee Shop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: const OnboardingScreen(),
    );
  }
}
