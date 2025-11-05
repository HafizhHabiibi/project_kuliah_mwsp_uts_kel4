import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/bottom_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: Stack(
        children: [
          // Konten halaman (contoh scrollable)
          ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              Text("Ini konten halaman home"),
              SizedBox(height: 800),
            ],
          ),

          // Overlay bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavOverlay(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
