import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RewardsPage extends StatefulWidget {
  const RewardsPage({super.key});

  @override
  State<RewardsPage> createState() => _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  final ScrollController _scrollController = ScrollController();
  bool isScrolledDown = false;

  static const Color primaryColor = Color(0xFF3A2D46); // Coklat
  static const Color secondaryColor = Color(0xFFFFAF36); // Kuning

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.offset > 10 && !isScrolledDown) {
        setState(() {
          isScrolledDown = true;
        });
      } else if (_scrollController.offset <= 10 && isScrolledDown) {
        setState(() {
          isScrolledDown = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarTextColor = isScrolledDown ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: isScrolledDown ? Colors.white : primaryColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Rewards",
          style: TextStyle(fontWeight: FontWeight.bold, color: appBarTextColor),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appBarTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Icon(Icons.more_vert, color: appBarTextColor),
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Box reward tetap coklat
            Container(
              padding: const EdgeInsets.only(top: 100, bottom: 40),
              decoration: const BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(22),
                  bottomRight: Radius.circular(22),
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/images/svg/gift.svg',
                        height: 150,
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 24,
                          ),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text(
                            '80 Pts',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Weekly Coffee Challenge",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text:
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et",
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          TextSpan(
                            text: " Read More",
                            style: TextStyle(
                              color: secondaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Progress Section
            Container(
              color: primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Progress",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "2 order left",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      bool active = index < 3;
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          height: 12,
                          decoration: BoxDecoration(
                            color: active
                                ? secondaryColor
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // History Rewards
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "History Reward",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text("More", style: TextStyle(color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  rewardCard(
                    title: "Buy 10 Brewed Coffee Packages",
                    points: "40 Pts",
                  ),
                  rewardCard(
                    title: "Extra Deluxe Gayo Coffee Packages",
                    points: "90 Pts",
                  ),
                  const SizedBox(
                    height: 50,
                  ), // padding bawah agar scroll lebih jauh
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rewardCard({required String title, required String points}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF2DE),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Text(
              points,
              style: const TextStyle(
                color: Color(0xFFFFAF36),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
