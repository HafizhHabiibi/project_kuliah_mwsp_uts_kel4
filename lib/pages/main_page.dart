import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

// Imports internal project
import 'package:project_kuliah_mwsp_uts_kel4/components/bottom_bar.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/detail_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/cart_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/product_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/notifications_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/product_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/auth_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/cart_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/models/product_model.dart';
import 'package:project_kuliah_mwsp_uts_kel4/models/user_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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

  // User data state
  UserModel? _currentUser;
  bool _isLoadingUser = true;

  // Featured products state
  bool _featuredLoading = true;
  String? _featuredError;
  List<ProductModel> _featuredProducts = const [];

  // TAMBAHAN: State untuk promo products
  bool _promoLoading = true;
  String? _promoError;
  List<ProductModel> _promoProducts = const [];

  // TAMBAHAN: State untuk menyimpan jumlah produk per kategori
  Map<String, int> _categoryProductCount = {};
  bool _categoryCountLoading = true;

  // Flag untuk tracking apakah sudah pernah load
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadFeaturedProducts();
    _loadPromoProducts();
    _loadCategoryProductCount();
  }

  // FUNGSI UNTUK GREETING DINAMIS
  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 11) {
      return "Good Morning";
    } else if (hour >= 11 && hour < 15) {
      return "Good Afternoon";
    } else if (hour >= 15 && hour < 18) {
      return "Good Evening";
    } else {
      return "Good Night";
    }
  }

  // ✅ FUNGSI BARU: Load dan hitung jumlah produk per kategori
  Future<void> _loadCategoryProductCount() async {
    setState(() {
      _categoryCountLoading = true;
    });
    try {
      final result = await _productService.getAllProducts();
      if (mounted && result['success'] == true) {
        final List<ProductModel> products = result['products'] as List<ProductModel>;
        
        // Hitung jumlah produk per kategori
        final Map<String, int> countMap = {};
        for (var product in products) {
          final category = product.kategori;
          countMap[category] = (countMap[category] ?? 0) + 1;
        }

        setState(() {
          _categoryProductCount = countMap;
          _categoryCountLoading = false;
        });
        print('✅ Jumlah produk per kategori: $_categoryProductCount');
      } else {
        setState(() {
          _categoryCountLoading = false;
        });
        print('⚠️ Gagal memuat jumlah produk per kategori');
      }
    } catch (e) {
      setState(() {
        _categoryCountLoading = false;
      });
      print('❌ Error loading category product count: $e');
    }
  }

  // ✅ FUNGSI HELPER: Ambil jumlah produk berdasarkan kategori
  int _getProductCount(String category) {
    return _categoryProductCount[category] ?? 0;
  }

  // Load user data from AuthService
  Future<void> _loadUserData() async {
    // Jangan set loading true jika ini bukan load pertama kali
    // agar UI tidak berkedip
    if (!_hasLoadedOnce) {
      setState(() {
        _isLoadingUser = true;
      });
    }
    try {
      final result = await AuthService().getUserInfo();
      if (result['success'] == true && result['user'] != null) {
        setState(() {
          _currentUser = result['user'] as UserModel;
          _isLoadingUser = false;
          _hasLoadedOnce = true;
        });
        // Initialize cart service with user ID
        CartService().setCurrentUser(_currentUser!.id.toString());
        print(
          '✅ User session initialized: ${_currentUser!.username} (ID: ${_currentUser!.id})',
        );
        // Load cart from backend
        await CartService().loadCartFromBackend();
      } else {
        setState(() {
          _isLoadingUser = false;
          _hasLoadedOnce = true;
        });
        print('⚠️ No user session found');
        CartService().setCurrentUser(null);
      }
    } catch (e) {
      setState(() {
        _isLoadingUser = false;
        _hasLoadedOnce = true;
      });
      print('❌ Error loading user data: $e');
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
          _featuredError = (result['message'] ?? 'Gagal memuat produk').toString();
          _featuredLoading = false;
        }
      });
    }
  }

  Future<void> _loadPromoProducts() async {
    setState(() {
      _promoLoading = true;
      _promoError = null;
    });
    try {
      // Ambil semua produk atau produk tertentu
      final result = await _productService.getAllProducts();
      if (mounted) {
        setState(() {
          if (result['success'] == true) {
            _promoProducts = result['products'] as List<ProductModel>;
            _promoLoading = false;
            // DEBUG: Print semua produk untuk melihat nama yang tersedia
            print('🔍 Total produk dimuat: ${_promoProducts.length}');
            for (var product in _promoProducts) {
              print(' - ${product.nama} (Kategori: ${product.kategori})');
            }
          } else {
            _promoError = result['message']?.toString() ?? 'Gagal memuat promo';
            _promoLoading = false;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _promoError = 'Error: $e';
          _promoLoading = false;
        });
      }
      print('❌ Error loading promo products: $e');
    }
  }

  // FUNGSI HELPER: Cari produk berdasarkan NAMA LENGKAP atau keyword spesifik
  ProductModel? _findProductByKeyword(String keyword) {
    try {
      // Strategi pencarian berlapis untuk akurasi lebih tinggi
      ProductModel? foundProduct;

      // 1. Coba cari dengan nama lengkap (case insensitive)
      try {
        foundProduct = _promoProducts.firstWhere(
          (product) => product.nama.toLowerCase() == keyword.toLowerCase(),
        );
        print('✅ Produk ditemukan (exact match): ${foundProduct.nama}');
        return foundProduct;
      } catch (e) {
        // Lanjut ke strategi berikutnya
      }

      // 2. Coba cari dengan keyword di awal nama
      try {
        foundProduct = _promoProducts.firstWhere(
          (product) => product.nama.toLowerCase().startsWith(keyword.toLowerCase()),
        );
        print('✅ Produk ditemukan (starts with): ${foundProduct.nama}');
        return foundProduct;
      } catch (e) {
        // Lanjut ke strategi berikutnya
      }

      // 3. Coba cari dengan contains (paling fleksibel tapi bisa salah)
      try {
        foundProduct = _promoProducts.firstWhere(
          (product) => product.nama.toLowerCase().contains(keyword.toLowerCase()),
        );
        print('⚠️ Produk ditemukan (contains): ${foundProduct.nama}');
        return foundProduct;
      } catch (e) {
        print('❌ Produk tidak ditemukan untuk keyword: "$keyword"');
        return null;
      }
    } catch (e) {
      print('❌ Error saat mencari produk: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while user data is loading (only first time)
    if (_isLoadingUser && !_hasLoadedOnce) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

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
                            Text(
                              _getGreeting(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentUser?.username ?? "Guest",
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
                        "Promotions",
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
                              builder: (context) => ProductPage(
                                categoryName: 'Promotions', // Kategori Promotions
                                initialCategory: 'Promotions',
                              ),
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
                    child: _promoLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _promoError != null
                            ? Center(
                                child: Text(
                                  _promoError!,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              )
                            : PageView(
                                controller: PageController(viewportFraction: 0.9),
                                children: [
                                  _buildPromoCard(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4A3749),
                                        Color(0xFF24182E),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    title: "Hot Mocha\nCappuccino Latte",
                                    productKeyword: "Hot Mocha Cappuccino Latte",
                                    image: "assets/images/background/pic1.png",
                                  ),
                                  _buildPromoCard(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFFF5F5F),
                                        Color(0xFFFF0000),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    title: "Hot Sweet\nIndonesian Tea",
                                    productKeyword: "Hot Sweet Indonesian Tea",
                                    image: "assets/images/background/pic2.png",
                                  ),
                                  _buildPromoCard(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF4A3749),
                                        Color(0xFF24182E),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    title: "Espresso\nBold Edition",
                                    productKeyword: "Espresso Bold Edition",
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
                    child: _categoryCountLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: [
                              _buildCategoryCard(
                                svgPath: "assets/images/svg/kopi.svg",
                                title: "Beverages",
                                subtitle: "${_getProductCount('Beverages')} Menus",
                              ),
                              _buildCategoryCard(
                                svgPath: "assets/images/svg/burger.svg",
                                title: "Foods",
                                subtitle: "${_getProductCount('Foods')} Menus",
                              ),
                              _buildCategoryCard(
                                svgPath: "assets/images/svg/pizza.svg",
                                title: "Pizza",
                                subtitle: "${_getProductCount('Pizza')} Menus",
                              ),
                              _buildCategoryCard(
                                svgPath: "assets/images/svg/drink.svg",
                                title: "Drink",
                                subtitle: "${_getProductCount('Drink')} Menus",
                              ),
                              _buildCategoryCard(
                                svgPath: "assets/images/svg/lunch.svg",
                                title: "Lunch",
                                subtitle: "${_getProductCount('Lunch')} Menus",
                              ),
                              _buildCategoryCard(
                                svgPath: "assets/images/svg/burger.svg",
                                title: "Burger",
                                subtitle: "${_getProductCount('Burger')} Menus",
                              ),
                            ],
                          ),
                  ),

                  const SizedBox(height: 30),

                  // ===== FEATURED PRODUCTS =====
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
    if (_currentUser?.gambarUrl != null && _currentUser!.gambarUrl!.isNotEmpty) {
      return Image.network(
        _currentUser!.gambarUrl!,
        height: 45,
        width: 45,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return _defaultAvatar();
        },
      );
    }
    return _defaultAvatar();
  }

  Widget _defaultAvatar() {
    return Image.asset(
      'assets/images/default/default_img.jpg',
      height: 45,
      width: 45,
      fit: BoxFit.cover,
    );
  }

  // ===== PROMO CARD (UPDATED) =====
  Widget _buildPromoCard({
    required LinearGradient gradient,
    required String title,
    required String productKeyword, // Keyword untuk mencari produk
    required String image,
  }) {
    // Cari produk berdasarkan keyword
    final product = _findProductByKeyword(productKeyword);

    // Ambil harga dari produk atau gunakan default
    final price = product != null ? _currencyFmt.format(product.harga) : "\$0.00";

    // Hitung harga coret (misalnya harga asli + 40%)
    final oldPrice = product != null
        ? _currencyFmt.format(product.harga * 1.4)
        : "\$0.00";

    return InkWell(
      // TAMBAHAN: Navigasi ke DetailPage saat card diklik
      onTap: () {
        if (product != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailPage(product: product),
            ),
          );
        } else {
          // Tampilkan pesan jika produk tidak ditemukan
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Produk "$title" tidak ditemukan'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      },
      child: Container(
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
                          // Harga dari database
                          Text(
                            price,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Harga coret (harga asli + markup)
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
        // Navigasi ke ProductPage dengan kategori yang dipilih
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
              categoryName: title,
              initialCategory: title,
            ),
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
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: product.gambarUrl != null && product.gambarUrl!.isNotEmpty
                      ? Image.network(
                          product.gambarUrl!,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return Image.asset(
                              'assets/images/menus/slide/pic1.jpg',
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            );
                          },
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