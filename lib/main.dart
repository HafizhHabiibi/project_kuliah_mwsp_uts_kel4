import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_kuliah_mwsp_uts_kel4/screen/getstarted_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // ✅ Inisialisasi Firebase
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
