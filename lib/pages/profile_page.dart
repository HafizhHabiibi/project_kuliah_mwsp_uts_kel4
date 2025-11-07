import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/messages_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/detail_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/store_locations_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotateController;
  bool showCallSection = false;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
      drawer: const SideBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // 🔹 App Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        "Profile",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 0),
                      child: Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                          ),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // 🔹 Profile Avatar
              Stack(
                alignment: Alignment.center,
                children: [
                  Transform.scale(
                    scale: 1.6,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromRGBO(255, 255, 255, 0.1),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.3,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color.fromRGBO(225, 207, 167, 1),
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/avatar/5.jpg"),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(125, 91, 124, 1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        "456 Pts",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),
              const Text(
                "Kevin Hard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.circle, size: 10, color: Colors.green),
                  SizedBox(width: 6),
                  Text(
                    "London, England",
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // 🔹 Action Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _circleAction(
                      svgPath: 'assets/images/svg/icons/call_icon.svg',
                      color: const Color(0xFF44474F),
                      isActive: showCallSection,
                      onTap: () {
                        setState(() {
                          showCallSection = true;
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    // 🔸 MAP ICON → Navigasi ke StoreLocationsPage
                    _circleAction(
                      svgPath: 'assets/images/svg/icons/locate_icon.svg',
                      color: const Color(0xFF44474F),
                      onTap: () {
                        setState(() {
                          showCallSection = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const StoreLocationsPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _circleAction(
                      svgPath: 'assets/images/svg/icons/mail_icon.svg',
                      color: const Color(0xFF44474F),
                      onTap: () {
                        setState(() {
                          showCallSection = false;
                        });
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MessagesPage(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    _circleAction(
                      svgPath: 'assets/images/svg/icons/pen_icon.svg',
                      color: showCallSection
                          ? const Color(0xFF44474F)
                          : Colors.white,
                      background: showCallSection
                          ? Colors.white
                          : const Color.fromRGBO(156, 156, 156, 0.5),
                      onTap: () {
                        setState(() {
                          showCallSection = false;
                        });
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔹 Bottom Section
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 100),
                child: showCallSection
                    ? _buildCallSection(context)
                    : _buildFavouriteMenus(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔸 Action Circle
  Widget _circleAction({
    required String svgPath,
    Color? color,
    Color background = Colors.white,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: isActive
              ? const Color.fromRGBO(156, 156, 156, 0.5)
              : background,
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: SvgPicture.asset(
            svgPath,
            color: isActive ? Colors.white : color,
            width: 24,
            height: 24,
          ),
        ),
      ),
    );
  }

  // 🔹 Favourite Menu Section
  Widget _buildFavouriteMenus(BuildContext context) {
    return Container(
      key: const ValueKey('favourite'),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 260,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Favourite Menus",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 15),
            _menuItem(
              context: context,
              image: "assets/images/menus/list/pic1.jpg",
              title: "Brewed Coppuccino Latte with Creamy Milk",
              category: "Food",
              price: "\$5.8",
              rating: "4.0",
            ),
            const SizedBox(height: 15),
            _menuItem(
              context: context,
              image: "assets/images/menus/list/pic2.jpg",
              title: "Melted Omelette with Spicy Chilli",
              category: "Food",
              price: "\$8.2",
              rating: "4.0",
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Call Section
  Widget _buildCallSection(BuildContext context) {
    return Container(
      key: const ValueKey('callSection'),
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height - 260,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        children: [
          _phoneCard("123 456 7890"),
          const SizedBox(height: 15),
          _phoneCard("987 654 3210"),
        ],
      ),
    );
  }

  Widget _phoneCard(String number) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(74, 55, 73, 1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.call, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 15),
          Text(
            number,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black87,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Color.fromRGBO(6, 195, 106, 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              "CALL",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Menu Item Widget (klik menuju DetailPage)
  Widget _menuItem({
    required BuildContext context,
    required String image,
    required String title,
    required String category,
    required String price,
    required String rating,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DetailPage()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                width: 65,
                height: 65,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(156, 156, 156, 1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SvgPicture.asset(
                        'assets/images/svg/icons/star_icon.svg',
                        color: const Color.fromRGBO(74, 55, 73, 1),
                        width: 18,
                        height: 18,
                      ),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
