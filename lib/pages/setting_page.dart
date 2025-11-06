import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isDarkMode = false;
  Color selectedThemeColor = const Color(0xFF007AFF); // default biru
  final TextEditingController customColorController = TextEditingController(
    text: "#007AFF",
  );

  // Daftar warna tema dan nama-namanya
  final List<Map<String, dynamic>> themeColors = [
    {"name": "Red", "color": Colors.red},
    {"name": "Green", "color": Colors.green},
    {"name": "Blue", "color": Colors.blue},
    {"name": "Pink", "color": Colors.pink},
    {"name": "Yellow", "color": Colors.yellow},
    {"name": "Orange", "color": Colors.orange},
    {"name": "Purple", "color": Colors.purple},
    {"name": "Deeppurple", "color": Colors.deepPurple},
    {"name": "Lightblue", "color": Colors.lightBlue},
    {"name": "Teal", "color": Colors.teal},
    {"name": "Lime", "color": Colors.lime},
    {"name": "Deeporange", "color": Colors.deepOrange},
  ];

  // Color picker langsung ubah warna real-time
  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Pick a color"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: selectedThemeColor,
            onColorChanged: (color) {
              setState(() {
                selectedThemeColor = color;
                customColorController.text =
                    "#${color.value.toRadixString(16).substring(2).toUpperCase()}";
              });
            },
            enableAlpha: false,
            displayThumbColor: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arrowColor = isDarkMode ? Colors.white : Colors.black87;
    final textColor = isDarkMode ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: arrowColor, size: 26),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Color Themes",
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Text(
              "Link",
              style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionCard(
              title: "Layout Themes",
              description:
                  "Framework7 comes with 2 main layout themes: Light (default) and Dark:",
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _themeOption(
                    title: "Light",
                    color: Colors.white,
                    selected: !isDarkMode,
                    onTap: () => setState(() => isDarkMode = false),
                  ),
                  _themeOption(
                    title: "Dark",
                    color: Colors.black,
                    selected: isDarkMode,
                    onTap: () => setState(() => isDarkMode = true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              title: "Default Color Themes",
              description: "Framework7 comes with 12 color themes set.",
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: themeColors.map((data) {
                  final color = data["color"] as Color;
                  final name = data["name"] as String;
                  final isSelected = selectedThemeColor == color;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedThemeColor = color;
                        customColorController.text =
                            "#${color.value.toRadixString(16).substring(2).toUpperCase()}";
                      });
                    },
                    child: Container(
                      width: 90,
                      height: 36,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected ? Colors.black : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child: Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            // --- BAGIAN CUSTOM COLOR BARU ---
            _buildSectionCard(
              title: "Custom Color Theme",
              description: "Pick your own HEX color:",
              child: GestureDetector(
                onTap: _showColorPicker,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F3F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: selectedThemeColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "HEX Color",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            customColorController.text,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: selectedThemeColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            label: 'Inbox',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Upload'),
        ],
        onTap: (_) {},
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required String description,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: selectedThemeColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 13, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _themeOption({
    required String title,
    required Color color,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected ? selectedThemeColor : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: selected
                ? Icon(
                    Icons.check_box_rounded,
                    color: selectedThemeColor,
                    size: 24,
                  )
                : null,
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}
