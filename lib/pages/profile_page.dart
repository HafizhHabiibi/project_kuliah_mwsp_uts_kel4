import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import '../pages/edit_profile_page.dart';
import '../pages/messages_page.dart';
import '../pages/store_locations_page.dart';
import '../components/sidebar.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool showCallSection = false;
  UserModel? _currentUser;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ================= LOAD USER =================
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      final result = await AuthService().getUserInfo();
      if (result['success'] == true && result['user'] != null) {
        _currentUser = result['user'] as UserModel;
      }
    } catch (_) {}

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text("Profile"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadUserData),
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),
      drawer: const SideBar(),
      drawerEnableOpenDragGesture: false,

      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.white))
          : Column(
              children: [
                const SizedBox(height: 20),

                // ===== AVATAR & USER INFO =====
                _buildUserInfo(),

                const SizedBox(height: 24),

                // ===== ACTION ICONS =====
                _buildActionIcons(),

                const SizedBox(height: 20),

                // ===== BOTTOM SECTION (SWITCHABLE) =====
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    transitionBuilder: (child, animation) {
                      final curved = CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutCubic,
                      );

                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0, 0.12),
                          end: Offset.zero,
                        ).animate(curved),
                        child: FadeTransition(opacity: curved, child: child),
                      );
                    },
                    child: showCallSection
                        ? _buildCallSection()
                        : _buildFavouriteSection(),
                  ),
                ),
              ],
            ),
    );
  }

  // ================= USER INFO =================
  Widget _buildUserInfo() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color.fromRGBO(226, 201, 150, 1),
                  width: 4,
                ),
              ),
            ),
            CircleAvatar(
              radius: 55,
              backgroundColor: Colors.grey[300],
              backgroundImage: _currentUser?.gambarUrl != null
                  ? NetworkImage(_currentUser!.gambarUrl!)
                  : null,
              child: _currentUser?.gambarUrl == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _currentUser?.username ?? "-",
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _currentUser?.alamat ?? "Alamat Kosong",
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  // ================= ACTION ICONS =================
  Widget _buildActionIcons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _circleAction(
          icon: Icons.phone,
          isActive: showCallSection,
          onTap: () {
            setState(() => showCallSection = !showCallSection);
          },
        ),
        _circleAction(
          icon: Icons.location_on,
          onTap: () {
            setState(() => showCallSection = false);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const StoreLocationsPage()),
            );
          },
        ),
        _circleAction(
          icon: Icons.email,
          onTap: () {
            setState(() => showCallSection = false);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MessagesPage()),
            );
          },
        ),
        _circleAction(
          icon: Icons.edit,
          onTap: () async {
            setState(() => showCallSection = false);
            final updatedUser = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => EditProfilePage(currentUser: _currentUser),
              ),
            );
            if (updatedUser is UserModel) {
              setState(() => _currentUser = updatedUser);
            }
          },
        ),
      ],
    );
  }

  // ================= CALL SECTION =================
  Widget _buildCallSection() {
    return Container(
      key: const ValueKey("call"),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: const [
          _PhoneCard(number: "123 456 7890"),
          SizedBox(height: 12),
          _PhoneCard(number: "987 654 3210"),
        ],
      ),
    );
  }

  // ================= FAVOURITE SECTION =================
  Widget _buildFavouriteSection() {
    return Container(
      key: const ValueKey("fav"),
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Favourite Menus",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          _favouriteItem(
            title: "Brewed Cappuccino Latte with Creamy Milk",
            price: "\$5.8",
            rating: "4.0",
            image: "assets/images/cart/pic1.jpg",
          ),
          _favouriteItem(
            title: "Melted Omelette with Spicy Chilli",
            price: "\$8.2",
            rating: "4.0",
            image: "assets/images/cart/pic2.jpg",
          ),
        ],
      ),
    );
  }

  // ================= REUSABLE =================
  Widget _circleAction({
    required IconData icon,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(40),
        child: CircleAvatar(
          radius: 22,
          backgroundColor: isActive ? Colors.black : Colors.white,
          child: Icon(icon, color: isActive ? Colors.white : Colors.black),
        ),
      ),
    );
  }

  static Widget _favouriteItem({
    required String title,
    required String price,
    required String rating,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(image, width: 56, height: 56, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Text("$price   ⭐ $rating"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ================= PHONE CARD =================
class _PhoneCard extends StatelessWidget {
  final String number;
  const _PhoneCard({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color.fromRGBO(74, 55, 73, 1),
            child: Icon(Icons.call, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Text(
            number,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
