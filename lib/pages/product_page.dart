import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/main_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/cart_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/detail_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/product_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/models/product_model.dart';

class ProductPage extends StatefulWidget {
  final String categoryName;

  const ProductPage({super.key, required this.categoryName});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  TabController? _tabController;
  final ProductService _productService = ProductService();
  final NumberFormat _currencyFmt = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 2,
  );

  List<ProductModel> allProducts = [];
  List<ProductModel> filteredProducts = [];
  List<String> categories = [];

  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _tabController?.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch all products
      print('🔍 [ProductPage] Fetching products...');
      final productsResult = await _productService.getAllProducts();

      if (productsResult['success'] == true) {
        final List<ProductModel> products = productsResult['products'] ?? [];
        print('✅ [ProductPage] Loaded ${products.length} products');
        
        // Extract unique categories from products
        final Set<String> uniqueCategories = {};
        for (var product in products) {
          uniqueCategories.add(product.kategori);
        }
        final List<String> extractedCategories = uniqueCategories.toList();
        extractedCategories.sort(); // Sort alphabetically
        
        print('✅ [ProductPage] Extracted categories: $extractedCategories');

        setState(() {
          allProducts = products;
          filteredProducts = List.from(allProducts);
          categories = extractedCategories;
          
          // Initialize TabController after we have categories
          _tabController = TabController(length: categories.length, vsync: this);
          _tabController?.addListener(_onTabChanged);
          
          isLoading = false;
        });
        print('✅ [ProductPage] TabController initialized with ${categories.length} tabs');
      } else {
        setState(() {
          errorMessage = productsResult['message'] ?? 'Failed to load products';
          isLoading = false;
        });
        print('❌ [ProductPage] Failed to load products: $errorMessage');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
      print('❌ [ProductPage] Exception: $e');
    }
  }

  void _onTabChanged() {
    if (_tabController != null && !_tabController!.indexIsChanging) {
      _filterByCategory(_tabController!.index);
    }
  }

  void _filterByCategory(int index) {
    if (index < 0 || index >= categories.length) return;
    
    final selectedCategory = categories[index];
    setState(() {
      filteredProducts = allProducts
          .where((product) => product.kategori == selectedCategory)
          .toList();
    });
  }

  void _searchProduct(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredProducts = List.from(allProducts);
      } else {
        filteredProducts = allProducts
            .where(
              (item) => item.nama.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
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
            if (!isLoading && errorMessage == null && _tabController != null)
              Container(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController!,
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
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4A3749),
                      ),
                    )
                  : errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 60,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF4A3749),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : _tabController == null
                          ? const Center(
                              child: Text(
                                'Loading...',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            )
                          : TabBarView(
                          controller: _tabController!,
                          children: categories.map((category) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: filteredProducts.isEmpty
                                  ? const Center(
                                      child: Text(
                                        'No products found',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    )
                                  : GridView.builder(
                                      itemCount: filteredProducts.length,
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 1.05,
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
                                                builder: (context) => DetailPage(product: product),
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
                                                      child: product.gambarUrl != null && product.gambarUrl!.isNotEmpty
                                                          ? Image.network(
                                                              product.gambarUrl!,
                                                              height: 120,
                                                              width: double.infinity,
                                                              fit: BoxFit.cover,
                                                              errorBuilder: (context, error, stackTrace) {
                                                                return Container(
                                                                  height: 120,
                                                                  color: Colors.grey[300],
                                                                  child: const Icon(
                                                                    Icons.image_not_supported,
                                                                    size: 50,
                                                                    color: Colors.grey,
                                                                  ),
                                                                );
                                                              },
                                                            )
                                                          : Container(
                                                              height: 120,
                                                              color: Colors.grey[300],
                                                              child: const Icon(
                                                                Icons.coffee,
                                                                size: 50,
                                                                color: Colors.grey,
                                                              ),
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
                                                        product.nama,
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
                                                        product.kategori,
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
                                                            _currencyFmt.format(product.harga),
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
