import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/reward_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/cart_page.dart';

class BottomNavOverlay extends StatefulWidget {
  final int? selectedIndex;
  final Function(int)? onItemTapped;

  const BottomNavOverlay({super.key, this.selectedIndex, this.onItemTapped});

  @override
  State<BottomNavOverlay> createState() => _BottomNavOverlayState();
}

class _BottomNavOverlayState extends State<BottomNavOverlay> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0; // default icon rumah aktif
  }

  void _handleTap(BuildContext context, int index) {
    setState(() {
      _selectedIndex = index;
    });

    widget.onItemTapped?.call(index);

    if (index == 1) {
      // Navigasi ke CartPage, dan reset ke Home setelah kembali
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0; // balik ke Home icon aktif
        });
      });
    } else if (index == 2) {
      // Navigasi ke RewardsPage, dan reset ke Home setelah kembali
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RewardsPage()),
      ).then((_) {
        setState(() {
          _selectedIndex = 0; // balik ke Home icon aktif
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color activeColor = Color(0xFF3E1F47);
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
      onTap: () => _handleTap(context, index),
      child: Icon(
        icon,
        size: 28,
        color: _selectedIndex == index ? active : inactive,
      ),
    );
  }
}
