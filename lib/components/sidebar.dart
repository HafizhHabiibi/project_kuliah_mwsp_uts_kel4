import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/reward_page.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 240,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Main Menu',
                    style: TextStyle(
                      fontSize: 24,
                      height: 1.3,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  // Close button in a bordered circle (matching design)
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      iconSize: 18,
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),

            // Menu list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 2),
                children: [
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/home_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Home',
                    selected: true,
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/search_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Search Menu',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/shop_cart_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Shop Cart',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/wishlist_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Wishlist',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/notifications_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Notifications (2)',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/store_location_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Store Locations',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/delivery_tracking_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Delivery Tracking',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/rewards_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Rewards',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RewardsPage(),
                      ),
                    ),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/profile_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Profile',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/order_reviews_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Order Review',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/message_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Message',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/elements_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Elements',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/setting_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Setting',
                    onTap: () => Navigator.pop(context),
                  ),
                  _MenuItem(
                    leading: SvgPicture.asset(
                      'assets/images/svg/icons/logout_icon.svg',
                      width: 24,
                      height: 24,
                    ),
                    title: 'Logout',
                    onTap: () => Navigator.pop(context),
                  ),
                  // Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Biji - Coffee Shop',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(177, 177, 195, 1),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'App Version 1.0.1',
                          style: TextStyle(color: Color.fromRGBO(177, 177, 195, 1), fontSize: 12),
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
  }
}

class _MenuItem extends StatelessWidget {
  final IconData? icon;
  final Widget? leading;
  final String title;
  final bool selected;
  final VoidCallback? onTap;

  const _MenuItem({
    this.icon,
    this.leading,
    required this.title,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedBg = const Color.fromRGBO(229, 218, 229, 1); // soft purple background
    final Color iconColor = selected
        ? Color.fromRGBO(74, 55, 73, 1)
        : Colors.grey.shade400;
    final Color textColor = selected
        ? Color.fromRGBO(74, 55, 73, 1)
        : Colors.grey.shade600;

  Widget leadingWidget;
    if (leading != null) {
      leadingWidget = leading!;
    } else if (icon != null) {
      leadingWidget = Icon(icon, color: iconColor, size: 24);
    } else {
      leadingWidget = const SizedBox(width: 24, height: 24);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 0),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? selectedBg : Colors.transparent,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Row(
              children: [
                leadingWidget,
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: textColor,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
