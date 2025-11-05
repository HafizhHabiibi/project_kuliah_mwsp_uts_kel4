import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/reward_page.dart';

class BottomNavOverlay extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const BottomNavOverlay({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFF3E1F47); // ungu tua seperti di gambar
    const Color inactiveColor = Colors.grey;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIcon(
            context,
            Icons.home_outlined,
            0,
            activeColor,
            inactiveColor,
          ),
          _buildIcon(
            context,
            Icons.shopping_bag_outlined,
            1,
            activeColor,
            inactiveColor,
          ),
          _buildIcon(
            context,
            Icons.storefront_outlined,
            2,
            activeColor,
            inactiveColor,
          ),
          _buildIcon(
            context,
            Icons.person_outline,
            3,
            activeColor,
            inactiveColor,
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(
    BuildContext context,
    IconData icon,
    int index,
    Color active,
    Color inactive,
  ) {
    return GestureDetector(
      onTap: () {
        onItemTapped(index);

        // 👇 Tambahkan aksi navigasi di sini
        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RewardsPage()),
          );
        }
      },
      child: Icon(
        icon,
        size: 28,
        color: selectedIndex == index ? active : inactive,
      ),
    );
  }
}
