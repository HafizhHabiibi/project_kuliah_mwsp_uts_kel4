import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/main_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/cart_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/detail_page.dart';

class ProductPage extends StatefulWidget {
  final String categoryName;

  const ProductPage({super.key, required this.categoryName});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  late TabController _tabController;

  List<Map<String, dynamic>> allProducts = [];
  List<Map<String, dynamic>> filteredProducts = [];

  List<String> categories = ["Beverages", "Brewed Coffee", "Blended Coffee"];

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: categories.length, vsync: this);

    allProducts = [
      {
        'name': 'White Cream Cappuccino',
        'price': 5.8,
        'category': 'Coffee',
        'image': 'assets/images/cart/pic1.jpg',
      },
      {
        'name': 'Hot Cappuccino Latte with Mocha',
        'price': 5.8,
        'category': 'Coffee',
        'image': 'assets/images/cart/pic2.jpg',
      },
      {
        'name': 'Mocha Coffee Creamy Milky',
        'price': 5.8,
        'category': 'Coffee',
        'image': 'assets/images/cart/pic3.jpg',
      },
      {
        'name': 'Creamy Latte Coffee',
        'price': 5.8,
        'category': 'Coffee',
        'image': 'assets/images/cart/pic4.jpg',
      },
    ];

    filteredProducts = List.from(allProducts);
  }

  void _searchProduct(String query) {
    setState(() {
      filteredProducts = allProducts
          .where(
            (item) => item['name'].toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ===== HEADER =====
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainPage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                    ),
                  ),
                  const Text(
                    "Products",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      return InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.more_vert_rounded,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ===== SEARCH BAR =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4F4F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: searchController,
                        onChanged: _searchProduct,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search, color: Colors.black54),
                          hintText: "Search here...",
                          hintStyle: TextStyle(color: Colors.black45),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.filter_alt_rounded,
                      color: Color(0xFF4A3749),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ===== TAB BAR =====
            Container(
              alignment: Alignment.centerLeft,
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                indicatorColor: const Color(0xFF4A3749),
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                tabs: categories.map((e) => Tab(text: e)).toList(),
              ),
            ),

            const SizedBox(height: 10),

            // ===== PRODUCT GRID =====
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GridView.builder(
                      itemCount: filteredProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.73,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];

                        // ==== CARD PRODUK YANG BISA DIKLIK ====
                        return InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const DetailPage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // ===== GAMBAR PRODUK =====
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                      child: Image.asset(
                                        product['image'],
                                        height: 120,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    // ===== IKON KERANJANG =====
                                    Positioned(
                                      bottom: 8,
                                      right: 8,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(50),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CartPage(),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 38,
                                          height: 38,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.15,
                                                ),
                                                blurRadius: 6,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: const Icon(
                                            Icons.shopping_bag_outlined,
                                            color: Color(0xFF4A3749),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // ===== DESKRIPSI PRODUK =====
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product['name'],
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        product['category'],
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.local_offer_outlined,
                                            color: Colors.black54,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            "\$${product['price'].toStringAsFixed(1)}",
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF4A3749),
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
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
