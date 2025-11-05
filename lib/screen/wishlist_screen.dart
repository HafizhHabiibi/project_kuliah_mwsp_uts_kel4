import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenPageState();
}

class _WishlistScreenPageState extends State<WishlistScreen> {
  bool isScrolledDown = true;

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> wishlistItems = [
      {
        "image": "assets/images/menus/pic1.jpg",
        "name": "Brown Hand Watch",
        "variant": "Variant : White Stripes",
        "price": "\$69.4",
      },
      {
        "image": "assets/images/menus/pic2.jpg",
        "name": "Possil Leather Watch",
        "variant": "Variant : White Stripes",
        "price": "\$69.4",
      },
      {
        "image": "assets/images/menus/pic3.jpg",
        "name": "Super Red Naiki Shoes",
        "variant": "Variant : White Stripes",
        "price": "\$69.4",
      },
      {
        "image": "assets/images/menus/pic4.jpg",
        "name": "Brown Hand Watch",
        "variant": "Variant : White Stripes",
        "price": "\$69.4",
      },
    ];
    final Color appBarTextColor = isScrolledDown ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Wishlist',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Colors.black87,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.more_vert, color: appBarTextColor),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ],
      ),
      drawer: const SideBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          children: [
            // Search bar
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(1, 1),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.grey, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search Here',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // List items
            Expanded(
              child: ListView.builder(
                itemCount: wishlistItems.length,
                itemBuilder: (context, index) {
                  final item = wishlistItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(
                          item["image"]!,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      title: Text(
                        item["name"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item["variant"]!,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item["price"]!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      trailing: const Icon(
                        Icons.favorite,
                        color: Color(0xFF4A3749),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
