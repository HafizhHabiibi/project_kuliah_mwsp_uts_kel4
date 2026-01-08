import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/screen/welcome_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  late final AnimationController _circle1Controller;
  late final AnimationController _circle2Controller;

  @override
  void initState() {
    super.initState();

    _circle1Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);

    _circle2Controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _circle1Controller.dispose();
    _circle2Controller.dispose();
    super.dispose();
  }

  final List<Map<String, String>> slides = [
    {
      "image": "assets/images/rank.png",
      "title": "Best coffee shop\nin this town",
      "desc":
          "Kopi pilihan dari biji terbaik, diseduh dengan standar kualitas tinggi.",
    },
    {
      "image": "assets/images/rank.png",
      "title": "Start your morning\nwith great coffee",
      "desc":
          "Temani pagimu dengan aroma kopi segar untuk memulai hari penuh semangat.",
    },
    {
      "image": "assets/images/rank.png",
      "title": "Taste from the\ngood old days",
      "desc":
          "Setiap tegukan membawa rasa klasik yang selalu dirindukan.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Background image
            Positioned.fill(
              child: Image.asset(
                'assets/images/background/linebg.png',
                fit: BoxFit.cover,
              ),
            ),

            // Main content dengan Column layout yang lebih terstruktur
            Column(
              children: [
                // PageView dengan Expanded agar mengisi ruang yang tersedia
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: slides.length,
                    onPageChanged: (index) {
                      setState(() => _currentIndex = index);
                    },
                    itemBuilder: (context, index) {
                      final slide = slides[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 50),
                            // Gambar ilustrasi
                            Image.asset(
                              slide['image']!,
                              height: 300, // Dikurangi sedikit untuk memberi ruang
                            ),
                            const SizedBox(height: 60),
                            // Title
                            Text(
                              slide['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            // Description
                            Text(
                              slide['desc']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Dots indicator - posisi di bawah content
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 10 : 10,
                        height: _currentIndex == index ? 10 : 10,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ),

                // Tombol Start dengan padding dari bawah
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: AnimatedStartButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const WelcomeScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 🌟 Tombol Start dengan animasi rotasi
class AnimatedStartButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedStartButton({super.key, required this.onPressed});

  @override
  State<AnimatedStartButton> createState() => _AnimatedStartButtonState();
}

class _AnimatedStartButtonState extends State<AnimatedStartButton>
    with TickerProviderStateMixin {
  late final AnimationController _circle1Controller;
  late final AnimationController _circle2Controller;
  late final Animation<double> _circle1Rotate;
  late final Animation<double> _circle2Rotate;

  @override
  void initState() {
    super.initState();

    _circle1Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );
    _circle2Controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _circle1Rotate = Tween<double>(begin: 2.5, end: 0).animate(
      CurvedAnimation(
        parent: _circle1Controller,
        curve: const Interval(0.12, 0.88, curve: Curves.easeInOut),
      ),
    );

    _circle2Rotate = Tween<double>(begin: -3.5, end: 0).animate(
      CurvedAnimation(
        parent: _circle2Controller,
        curve: const Interval(0.15, 0.85, curve: Curves.easeInOut),
      ),
    );

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _circle1Controller.repeat(reverse: true);
        _circle2Controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _circle1Controller.dispose();
    _circle2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: SizedBox(
        width: 105,
        height: 105,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circle 2 (outer circle)
            AnimatedBuilder(
              animation: _circle2Rotate,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _circle2Rotate.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/circle2.png',
                width: 104,
                height: 104,
                fit: BoxFit.contain,
              ),
            ),
            // Circle 1 (inner circle)
            AnimatedBuilder(
              animation: _circle1Rotate,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _circle1Rotate.value,
                  child: child,
                );
              },
              child: Image.asset(
                'assets/images/circle1.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
            // Button icon
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_forward_rounded,
                  size: 28,
                  color: Color.fromRGBO(74, 55, 73, 1),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}