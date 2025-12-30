import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/bottom_bar.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/detail_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/cart_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/product_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/notifications_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/product_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/auth_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/cart_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/models/product_model.dart';
import 'package:intl/intl.dart';

class MainPage extends StatefulWidget {
  final String? profileImagePath;
  final String userName;

  const MainPage({
    super.key,
    this.profileImagePath,
    this.userName = "Kevin Hard",
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  final ProductService _productService = ProductService();
  final NumberFormat _currencyFmt = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
  );

  bool _featuredLoading = true;
  String? _featuredError;
  List<ProductModel> _featuredProducts = const [];

  @override
  void initState() {
    super.initState();
    _initializeUserSession();
    _loadFeaturedProducts();
  }

  // Initialize user session in CartService
  Future<void> _initializeUserSession() async {
    // Check if user is already set (from login)
    if (CartService().currentUserId != null) {
      print('✅ User session already initialized (ID: ${CartService().currentUserId})');
      // Load cart from backend
      await CartService().loadCartFromBackend();
      return;
    }

    // Try to get user info from AuthService
    final authService = AuthService();
    final userInfo = await authService.getUserInfo();
    
    if (userInfo['success'] == true) {
      final user = userInfo['user'];
      // Set current user in CartService using user ID
      CartService().setCurrentUser(user.id.toString());
      print('✅ User session initialized from AuthService: ${user.username} (ID: ${user.id})');
      
      // Load cart from backend
      await CartService().loadCartFromBackend();
    } else {
      print('⚠️ No user session found');
      CartService().setCurrentUser(null);
    }
  }

  Future<void> _loadFeaturedProducts() async {
    setState(() {
      _featuredLoading = true;
      _featuredError = null;
    });

    final result = await _productService.getFeaturedProducts(limit: 8);
    if (mounted) {
      setState(() {
        if (result['success'] == true) {
          _featuredProducts = (result['products'] as List<ProductModel>);
          _featuredLoading = false;
        } else {
          _featuredError = (result['message'] ?? 'Gagal memuat produk')
              .toString();
          _featuredLoading = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== HEADER =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Klik pada nama untuk ke notifikasi
                      InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          Navigator.of(context).push(_createFadeRoute());
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Good Morning",
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.userName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(34, 34, 34, 1),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Klik pada foto profil untuk ke notifikasi
                      InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          Navigator.of(context).push(_createFadeRoute());
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: _buildProfileImage(),
                            ),
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: const BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ===== PROMOTION SECTION =====
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Promotion",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(34, 34, 34, 1),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductPage(categoryName: 'All'),
                            ),
                          );
                        },
                        child: const Text(
                          "More",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(74, 55, 73, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),

                  // ===== PROMO SWIPER =====
                  SizedBox(
                    height: 185,
                    child: PageView(
                      controller: PageController(viewportFraction: 0.9),
                      children: [
                        _buildPromoCard(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A3749), Color(0xFF24182E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          title: "Hot Mocha\nCappuccino Latte",
                          price: "\$5.8",
                          oldPrice: "\$9.9",
                          image: "assets/images/background/pic1.png",
                        ),
                        _buildPromoCard(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF5F5F), Color(0xFFFF0000)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          title: "Hot Sweet\nIndonesian Tea",
                          price: "\$2.5",
                          oldPrice: "\$5.4",
                          image: "assets/images/background/pic2.png",
                        ),
                        _buildPromoCard(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4A3749), Color(0xFF24182E)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          title: "Espresso\nBold Edition",
                          price: "\$4.2",
                          oldPrice: "\$6.0",
                          image: "assets/images/background/pic1.png",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== CATEGORY SECTION =====
                  const Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(34, 34, 34, 1),
                    ),
                  ),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 150,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        _buildCategoryCard(
                          svgPath: "assets/images/svg/kopi.svg",
                          title: "Beverages",
                          subtitle: "67 Menus",
                        ),
                        _buildCategoryCard(
                          svgPath: "assets/images/svg/burger.svg",
                          title: "Foods",
                          subtitle: "23 Menus",
                        ),
                        _buildCategoryCard(
                          svgPath: "assets/images/svg/pizza.svg",
                          title: "Pizza",
                          subtitle: "16 Menus",
                        ),
                        _buildCategoryCard(
                          svgPath: "assets/images/svg/drink.svg",
                          title: "Drink",
                          subtitle: "18 Menus",
                        ),
                        _buildCategoryCard(
                          svgPath: "assets/images/svg/lunch.svg",
                          title: "Lunch",
                          subtitle: "45 Menus",
                        ),
                        _buildCategoryCard(
                          svgPath: "assets/images/svg/burger.svg",
                          title: "Burger",
                          subtitle: "12 Menus",
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ===== FEATURED BEVERAGES =====
                  const Text(
                    "Featured Products",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(34, 34, 34, 1),
                    ),
                  ),
                  const SizedBox(height: 15),

                  SizedBox(
                    height: 240,
                    child: _featuredLoading
                        ? const Center(child: CircularProgressIndicator())
                        : (_featuredError != null)
                        ? Center(
                            child: Text(
                              _featuredError!,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : (_featuredProducts.isEmpty)
                        ? const Center(
                            child: Text(
                              'Belum ada produk',
                              style: TextStyle(color: Colors.black54),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: _featuredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _featuredProducts[index];
                              return _buildFeaturedProductCard(product);
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),

          // ===== FLOATING BOTTOM BAR =====
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: BottomNavOverlay(
              selectedIndex: _selectedIndex,
              onItemTapped: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  // ===== ANIMASI FADE UNTUK PINDAH HALAMAN =====
  Route _createFadeRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const NotificationsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }

  // ===== FOTO PROFIL =====
  Widget _buildProfileImage() {
    if (widget.profileImagePath != null &&
        widget.profileImagePath!.isNotEmpty) {
      final file = File(widget.profileImagePath!);
      if (file.existsSync()) {
        return Image.file(file, height: 45, width: 45, fit: BoxFit.cover);
      }
    }
    return Image.asset(
      'assets/images/profile/avatar1.jpg',
      height: 45,
      width: 45,
      fit: BoxFit.cover,
    );
  }

  // ===== PROMO CARD =====
  Widget _buildPromoCard({
    required LinearGradient gradient,
    required String title,
    required String price,
    required String oldPrice,
    required String image,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: gradient,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -60,
            left: -60,
            child: _softCircle(150, Colors.white.withOpacity(0.08)),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: _softCircle(150, Colors.white.withOpacity(0.08)),
          ),
          Positioned(
            top: 10,
            right: 85,
            child: _softCircle(30, Colors.white.withOpacity(0.12)),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: Image.asset(
              "assets/images/background/card-bg.png",
              fit: BoxFit.cover,
              color: Colors.white.withOpacity(0.05),
              colorBlendMode: BlendMode.srcOver,
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Text(
                          price,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          oldPrice,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Image.asset(image, height: 140, fit: BoxFit.contain),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _softCircle(double size, Color color) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  // ===== KATEGORI CARD =====
  Widget _buildCategoryCard({
    required String svgPath,
    required String title,
    required String subtitle,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(22),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(categoryName: title),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            colors: [Color(0xFF4A3749), Color(0xFF24182E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              bottom: -20,
              height: 100,
              width: 100,
              child: Opacity(
                opacity: 0.15,
                child: SvgPicture.asset(svgPath, color: Colors.white),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(svgPath, height: 32, color: Colors.white),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== FEATURED CARD =====
  Widget _buildFeaturedCard({
    required String image,
    required String category,
    required String name,
    required String price,
    required double rating,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // TODO: This hardcoded card needs product data to navigate to DetailPage
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => DetailPage(product: product)),
        // );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.asset(
                    image,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            price,
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

            // ===== TOMBOL KERANJANG =====
            Positioned(
              top: 80,
              right: 10,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF4A3749),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== FEATURED CARD (from ProductModel) =====
  Widget _buildFeaturedProductCard(ProductModel product) {
    final priceStr = _currencyFmt.format(product.harga);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailPage(product: product)),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child:
                      product.gambarUrl != null && product.gambarUrl!.isNotEmpty
                      ? Image.network(
                          product.gambarUrl!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/menus/slide/pic1.jpg',
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.kategori,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        product.nama,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text(
                                '4.5',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            priceStr,
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

            // ===== TOMBOL KERANJANG =====
            Positioned(
              top: 80,
              right: 10,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF4A3749),
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
