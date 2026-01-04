import 'package:flutter/material.dart';
import '../models/review_model.dart';
import '../services/rating_service.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class OrderReviewsPage extends StatefulWidget {
  final int? productId; // null kalau dibuka dari Sidebar (global)
  final String? productName;
  final String? productImageUrl;

  const OrderReviewsPage({
    super.key,
    this.productId,
    this.productName,
    this.productImageUrl,
  });

  @override
  State<OrderReviewsPage> createState() => _OrderReviewsPageState();
}

class _OrderReviewsPageState extends State<OrderReviewsPage> {
  double _rating = 3.0;
  final TextEditingController _reviewController = TextEditingController();
  List<ReviewModel> reviews = [];
  bool isLoading = true;

  final RatingService _ratingService = RatingService();
  final ProductService _productService = ProductService();
  int? currentUserId;

  List<ProductModel> allProducts = []; // Untuk mode Sidebar

  @override
  void initState() {
    super.initState();
    if (widget.productId != null) {
      _fetchReviews();
    } else {
      _fetchAllProducts();
    }
  }

  /// ===================== FETCH REVIEW SPESIFIK PRODUK =====================
  Future<void> _fetchReviews() async {
    setState(() => isLoading = true);
    try {
      final fetchedReviews = await _ratingService.fetchRatings(
        widget.productId!,
      );
      setState(() {
        reviews = fetchedReviews;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to load reviews: $e")));
    }
  }

  /// ===================== FETCH ALL PRODUCTS (SIDEBAR MODE) =====================
  Future<void> _fetchAllProducts() async {
    setState(() => isLoading = true);
    try {
      final result = await _productService.getAllProducts();
      if (result['success'] == true) {
        setState(() {
          allProducts = List<ProductModel>.from(result['products']);
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result['message'] ?? "Failed to load products"),
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  /// ===================== SUBMIT REVIEW =====================
  Future<void> _submitReview() async {
    if (widget.productId == null) return;

    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please write a review before submitting."),
        ),
      );
      return;
    }

    bool success = await _ratingService.submitRating(
      widget.productId!,
      _rating,
      _reviewController.text,
    );

    if (success) {
      _reviewController.clear();
      _rating = 3.0;
      await _fetchReviews();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Review submitted successfully!")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit review.")));
    }
  }

  /// ===================== AVERAGE RATING =====================
  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    double total = reviews.fold(0, (sum, r) => sum + r.rating);
    return total / reviews.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.productId != null
              ? 'Reviews for ${widget.productName}'
              : 'All Products Reviews',
          style: const TextStyle(
            color: Colors.black,
            letterSpacing: 0.5,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : widget.productId != null
          ? _buildProductReviewMode() // Dari Detail Page
          : _buildSidebarMode(), // Dari Sidebar
    );
  }

  /// ===================== WIDGET UNTUK DETAIL PAGE =====================
  Widget _buildProductReviewMode() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.productImageUrl != null)
            Center(child: Image.network(widget.productImageUrl!, height: 150)),
          const SizedBox(height: 12),
          Text("Your Rating:", style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Row(
            children: List.generate(5, (index) {
              final filled = index < _rating.round();
              return GestureDetector(
                onTap: () => setState(() => _rating = (index + 1).toDouble()),
                child: Icon(
                  filled ? Icons.star_rounded : Icons.star_border_rounded,
                  color: filled ? Colors.amber : Colors.grey.shade400,
                  size: 32,
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reviewController,
            maxLines: 4,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Write your review here",
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromRGBO(74, 55, 73, 1),
            ),
            child: const Text(
              "Submit Review",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber),
              const SizedBox(width: 4),
              Text(averageRating.toStringAsFixed(1)),
              const SizedBox(width: 8),
              Text("(${reviews.length} reviews)"),
            ],
          ),
          const SizedBox(height: 16),
          reviews.isEmpty
              ? const Text("No reviews yet.")
              : ListView.builder(
                  itemCount: reviews.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                review.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(review.rating.toString()),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(review.comment),
                        ],
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  /// ===================== WIDGET UNTUK SIDEBAR MODE =====================
  Widget _buildSidebarMode() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allProducts.length,
      itemBuilder: (context, index) {
        final product = allProducts[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: product.gambarUrl != null
                ? Image.network(
                    product.gambarUrl!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.image_not_supported),
            title: Text(product.nama),
            subtitle: const Text(
              "See Product Reviews",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            onTap: () {
              // Bisa navigasi ke review detail product
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderReviewsPage(
                    productId: product.idProduk,
                    productName: product.nama,
                    productImageUrl: product.gambarUrl,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
