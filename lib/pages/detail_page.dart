import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/cart_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/cart_service.dart';
import 'package:project_kuliah_mwsp_uts_kel4/services/wishlist_service.dart';
import '../models/product_model.dart';

class DetailPage extends StatefulWidget {
  final ProductModel product;

  const DetailPage({super.key, required this.product});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 1;
  String selectedSize = 'MD';
  bool isScrolled = false;
  bool isFavorite = false;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadFavoriteStatus();
  }

  void _scrollListener() {
    if (_scrollController.hasClients &&
        _scrollController.offset > 20 &&
        !isScrolled) {
      setState(() => isScrolled = true);
    } else if (_scrollController.hasClients &&
        _scrollController.offset <= 20 &&
        isScrolled) {
      setState(() => isScrolled = false);
    }
  }

  Future<void> _loadFavoriteStatus() async {
    try {
      final wishlist = await WishlistService().fetchWishlist();
      setState(() {
        isFavorite = wishlist.any((p) => p.idProduk == widget.product.idProduk);
      });
    } catch (e) {
      print('Failed to load wishlist: $e');
    }
  }

  Future<void> _toggleWishlist() async {
    final service = WishlistService();
    setState(() {
      // Optimistic UI update
      isFavorite = !isFavorite;
    });

    bool success = false;

    try {
      if (isFavorite) {
        success = await service.addToWishlist(widget.product.idProduk);
      } else {
        success = await service.removeFromWishlist(widget.product.idProduk);
      }
    } catch (e) {
      success = false;
    }

    if (!success) {
      // rollback UI kalau gagal
      setState(() {
        isFavorite = !isFavorite;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui wishlist!'),
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite ? 'Ditambahkan ke Wishlist!' : 'Dihapus dari Wishlist!',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice =
        widget.product.harga.toDouble() * (quantity == 0 ? 1 : quantity);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // ======== BACKGROUND ========
          IgnorePointer(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      widget.product.gambarUrl != null &&
                              widget.product.gambarUrl!.isNotEmpty
                          ? Image.network(
                              widget.product.gambarUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[300],
                                  child: const Icon(
                                    Icons.image_not_supported,
                                    size: 80,
                                    color: Colors.grey,
                                  ),
                                );
                              },
                            )
                          : Container(
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.coffee,
                                size: 80,
                                color: Colors.grey,
                              ),
                            ),
                      Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.black38, Colors.transparent],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(child: Container(color: Colors.white)),
              ],
            ),
          ),

          // ======== SCROLLABLE CONTENT ========
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels > 20 && !isScrolled) {
                setState(() => isScrolled = true);
              } else if (notification.metrics.pixels <= 20 && isScrolled) {
                setState(() => isScrolled = false);
              }
              return true;
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.45),
                  // ======== MAIN CONTENT ========
                  Container(
                    transform: Matrix4.translationValues(0, -35, 0),
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 35,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, -6),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.nama,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          widget.product.deskripsi ??
                              'Produk berkualitas tinggi dengan cita rasa yang lezat. Cocok untuk dinikmati kapan saja.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 17,
                            color: Colors.black54,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 28),
                        // ======== SIZE SELECTION ========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: ['SM', 'MD', 'LG', 'XL'].map((size) {
                            bool isSelected = size == selectedSize;
                            return GestureDetector(
                              onTap: () => setState(() => selectedSize = size),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 25,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFFFCFA7)
                                      : const Color(0xFFFFEBDA),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: isSelected
                                        ? Colors.orange
                                        : Colors.transparent,
                                  ),
                                ),
                                child: Text(
                                  size,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 17,
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.grey.shade600,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 35),
                        // ======== PRICE & QUANTITY ========
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(CupertinoIcons.tag, size: 22),
                                const SizedBox(width: 6),
                                Text(
                                  '\$${widget.product.harga.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (quantity > 1) quantity--;
                                      });
                                    },
                                    child: const Icon(Icons.remove, size: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      quantity.toString(),
                                      style: const TextStyle(fontSize: 17),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        quantity++;
                                      });
                                    },
                                    child: const Icon(Icons.add, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          '*) Dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore',
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.grey,
                            height: 1.3,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 35),
                        // ======== PLACE ORDER BUTTON ========
                        GestureDetector(
                          onTap: () {
                            CartService().addToCart(
                              widget.product,
                              quantity,
                              selectedSize,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${widget.product.nama} added to cart!',
                                  style: const TextStyle(color: Colors.white),
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CartPage(),
                              ),
                            );
                          },
                          child: AnimatedScale(
                            scale: 1,
                            duration: const Duration(milliseconds: 100),
                            child: Container(
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFF3A2D46),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      fontSize: 17,
                                    ),
                                    children: [
                                      const TextSpan(
                                        text: 'PLACE ORDER  ',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\$${totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Color(0xFFD3C1E5),
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ======== APPBAR ========
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 8,
              right: 8,
            ),
            decoration: BoxDecoration(
              color: isScrolled ? Colors.white : Colors.transparent,
              boxShadow: isScrolled
                  ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: isScrolled ? Colors.black : Colors.white,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Details',
                  style: TextStyle(
                    color: isScrolled ? Colors.black : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite
                        ? Colors.red
                        : (isScrolled ? Colors.red : Colors.white),
                  ),
                  onPressed: _toggleWishlist,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
