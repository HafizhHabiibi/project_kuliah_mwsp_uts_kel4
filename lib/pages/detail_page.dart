import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/checkout_page.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int quantity = 0;
  String selectedSize = 'MD';
  final double price = 5.8;

  final ScrollController _scrollController = ScrollController();
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset > 60 && !isScrolled) {
      setState(() => isScrolled = true);
    } else if (_scrollController.offset <= 60 && isScrolled) {
      setState(() => isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = price * (quantity == 0 ? 1 : quantity);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          color: isScrolled ? Colors.white : Colors.transparent,
          child: SafeArea(
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: isScrolled ? 1 : 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: isScrolled ? Colors.black : Colors.white,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'Details',
                style: TextStyle(
                  color: isScrolled ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(
                    Icons.bookmark_border,
                    color: isScrolled ? Colors.black : Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Gambar header
            Image.asset(
              'assets/images/background/bg4.jpg',
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            // Card putih konten
            Container(
              transform: Matrix4.translationValues(0, -25, 0),
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, -8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Creamy Latte Coffee',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim minim veniam',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Colors.black54),
                  ),
                  const SizedBox(height: 25),

                  // Tombol ukuran
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: ['SM', 'MD', 'LG', 'XL'].map((size) {
                      bool isSelected = size == selectedSize;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedSize = size);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFFFFE0B2)
                                : const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.orange
                                  : Colors.transparent,
                            ),
                          ),
                          child: Text(
                            size,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.black87
                                  : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 25),

                  // Harga dan jumlah
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            CupertinoIcons.tag_fill,
                            color: Colors.orange,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '\$${price.toStringAsFixed(1)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (quantity > 0) quantity--;
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
                                style: const TextStyle(fontSize: 16),
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

                  const SizedBox(height: 12),
                  const Text(
                    '*)Dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),

                  // Tombol Place Order
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color: Color(0xFF3A2D46),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Text(
                          'PLACE ORDER  \$${totalPrice.toStringAsFixed(1)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
