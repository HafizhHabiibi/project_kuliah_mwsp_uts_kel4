import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<Map<String, String>> pages = [
    {
      'image': 'assets/images/background/bg1.jpg',
      'title': 'Start your morning\nwith great coffee',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    },
    {
      'image': 'assets/images/background/bg2.jpg',
      'title': 'Best coffee shop\nin this town',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    },
    {
      'image': 'assets/images/background/bg3.jpg',
      'title': 'Taste from the\ngood old days',
      'subtitle': 'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Swiper
          PageView.builder(
            controller: _pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(pages[index]['image']!),
                    fit: BoxFit.contain,
                    alignment: Alignment.topCenter,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                        end: Alignment(0, 0.3),
                      colors: [
                        Colors.white.withOpacity(0.15), // ringan semi transparan di atas
                        Colors.white.withOpacity(1), // tebal putih di bawah
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 5),
                      // Logo Section
                      // Pindahkan logo ke atas dengan menggesernya ke atas menggunakan Transform
                      Transform.translate(
                        offset: Offset(0, -100),
                        child: Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background lingkaran utama
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        offset: const Offset(0, 5),
                                        blurRadius: 20,
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/images/svg/bean.svg',
                                      width: 40,
                                      height: 40,
                                    ),
                                  ),
                                ),

                                // Segitiga kecil di bawah
                                Positioned(
                                  bottom: -1,
                                  left: 10,
                                  child: Transform.rotate(
                                    angle: 83 * 3.14159 / 180, // rotasi 83 derajat
                                    child: Container(
                                      height: 25,
                                      width: 25,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              "BIJI",
                              style: TextStyle(
                                fontSize: 38,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(12, 12, 12, 1),
                                letterSpacing: 5,
                              ),
                            ),
                            const Text(
                              "Coffee Shop App",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(12, 12, 12, 1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 60),

                      // Text content
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          children: [
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 260),
                              child: Column(
                                children: [
                                  Text(
                                    pages[index]['title']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromRGBO(34, 34, 34, 1),
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Text(
                                    pages[index]['subtitle']!,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromRGBO(34, 34, 34, 0.5),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Page Indicator & Buttons
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: pages.length,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Color.fromRGBO(125, 91, 124, 1),
                    dotColor: Colors.black12,
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 6,
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(125, 91, 124, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // Arahkan ke halaman login
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color.fromRGBO(255, 255, 255, 1)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(255, 207, 167, 1),
                          foregroundColor: Color.fromRGBO(125, 91, 124, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          // Arahkan ke halaman sign up
                        },
                        child: const Text(
                          "SIGN UP FOR FREE",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
