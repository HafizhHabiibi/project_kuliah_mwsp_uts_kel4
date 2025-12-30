import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/wishlist_service.dart';
import '../components/sidebar.dart';
import '../pages/detail_page.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  bool _isLoading = true;
  List<ProductModel> _wishlist = [];
  List<ProductModel> _filteredItems = [];

  @override
  void initState() {
    super.initState();
    _loadWishlist();
    _searchController.addListener(_filterSearch);
  }

  Future<void> _loadWishlist() async {
    setState(() => _isLoading = true);
    try {
      final data = await WishlistService().fetchWishlist();
      setState(() {
        _wishlist = data;
        _filteredItems = data;
      });
    } catch (e) {
      print('Failed to load wishlist: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memuat wishlist'),
          duration: Duration(seconds: 2),
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _filterSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _wishlist
          .where(
            (item) =>
                item.nama.toLowerCase().contains(query) ||
                (item.deskripsi ?? '').toLowerCase().contains(query),
          )
          .toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = false;
      _filteredItems = _wishlist;
    });
  }

  Future<void> _removeFromWishlist(ProductModel product) async {
    try {
      final success = await WishlistService().removeFromWishlist(
        product.idProduk,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Produk dihapus dari wishlist'),
            duration: Duration(seconds: 2),
          ),
        );
        _loadWishlist();
      } else {
        throw Exception('Gagal menghapus');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus wishlist'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool showOverlay = _isSearching && _searchController.text.isEmpty;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
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
                icon: const Icon(Icons.more_vert, color: Colors.black87),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
          ),
        ],
      ),
      drawer: const SideBar(),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              /// 🔍 Search Bar
              WishlistSearchBar(
                controller: _searchController,
                isSearching: _isSearching,
                onFocusChange: (focus) => setState(() => _isSearching = focus),
                onClear: _clearSearch,
              ),
              const SizedBox(height: 20),

              /// 🧾 Wishlist List
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Stack(
                        children: [
                          _filteredItems.isEmpty
                              ? const Center(
                                  child: Text(
                                    "Wishlist masih kosong",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final product = _filteredItems[index];
                                    return WishlistItemCard(
                                      product: product,
                                      onRemove: () =>
                                          _removeFromWishlist(product),
                                      onTap: () async {
                                        // Navigasi ke DetailPage dan reload wishlist saat kembali
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                DetailPage(product: product),
                                          ),
                                        );
                                        _loadWishlist();
                                      },
                                    );
                                  },
                                ),

                          /// Overlay saat search fokus
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: showOverlay ? 0.5 : 0.0,
                            child: IgnorePointer(
                              ignoring: !showOverlay,
                              child: GestureDetector(
                                onTap: _clearSearch,
                                child: Container(
                                  color: Colors.black.withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//
// 🔍 SEARCH BAR
//
class WishlistSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isSearching;
  final Function(bool) onFocusChange;
  final VoidCallback onClear;

  const WishlistSearchBar({
    super.key,
    required this.controller,
    required this.isSearching,
    required this.onFocusChange,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Focus(
              onFocusChange: (focus) => onFocusChange(focus),
              child: TextField(
                controller: controller,
                cursorColor: const Color(0xFF4A3749),
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
          ),
          if (isSearching)
            GestureDetector(
              onTap: onClear,
              child: const Icon(Icons.close, color: Colors.grey),
            ),
        ],
      ),
    );
  }
}

//
// ❤️ WISHLIST ITEM CARD
//
class WishlistItemCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onRemove;
  final VoidCallback? onTap;

  const WishlistItemCard({
    super.key,
    required this.product,
    required this.onRemove,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: product.gambarUrl != null && product.gambarUrl!.isNotEmpty
              ? Image.network(
                  product.gambarUrl!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image, size: 40),
                )
              : const Icon(Icons.coffee, size: 40),
        ),
        title: Text(
          product.nama,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 15,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.kategori,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 5),
            Text(
              '\$ ${product.harga}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.favorite,
            color: Color.fromARGB(255, 252, 0, 0),
          ),
          onPressed: onRemove,
        ),
        onTap: onTap,
      ),
    );
  }
}
