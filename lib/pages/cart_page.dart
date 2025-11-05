import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  // Data dummy keranjang dengan gambar dari assets/images/cart/
  List<Map<String, dynamic>> allItems = [
    {
      "title": "Hot Sweet Indonesian Tea",
      "price": 5.8,
      "qty": 2,
      "image": "assets/images/cart/pic1.jpg",
      "status": "all",
    },
    {
      "title": "Mocha Coffee Creamy Milky",
      "price": 8.6,
      "qty": 1,
      "image": "assets/images/cart/pic2.jpg",
      "status": "delivery",
    },
    {
      "title": "Cappuccino Classic",
      "price": 7.5,
      "qty": 1,
      "image": "assets/images/cart/pic3.jpg",
      "status": "done",
    },
    {
      "title": "Latte Caramel Delight",
      "price": 6.2,
      "qty": 2,
      "image": "assets/images/cart/pic4.jpg",
      "status": "all",
    },
  ];

  String searchQuery = "";

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  List<Map<String, dynamic>> getFilteredItems(String status) {
    return allItems.where((item) {
      bool matchesSearch = item["title"].toString().toLowerCase().contains(
        searchQuery.toLowerCase(),
      );
      bool matchesTab = status == "all" ? true : item["status"] == status;
      return matchesSearch && matchesTab;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Cart", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
      ),
      body: Column(
        children: [
          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search Order ID or Product",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xfff5f5f5),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 0,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
          ),

          // 🔹 Tab Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(25),
            ),
            child: TabBar(
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  ),
                ],
              ),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Delivery"),
                Tab(text: "Done"),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // 🔹 List isi keranjang berdasarkan tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildCartList("all"),
                buildCartList("delivery"),
                buildCartList("done"),
              ],
            ),
          ),
        ],
      ),

      // 🔹 Floating “Place Order” button
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3A2D46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
          child: const Text(
            "PLACE ORDER",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  // 🔹 Widget daftar item keranjang
  Widget buildCartList(String status) {
    var items = getFilteredItems(status);

    if (items.isEmpty) {
      return const Center(child: Text("Nothing found"));
    }

    return ListView.builder(
      itemCount: items.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final item = items[index];
        return Dismissible(
          key: Key(item["title"]),
          direction: DismissDirection.endToStart,
          onDismissed: (_) {
            setState(() {
              allItems.remove(item);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${item['title']} removed from cart")),
            );
          },
          background: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    item["image"],
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$${item["price"]}   x${item["qty"]}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "\$${(item["price"] * item["qty"]).toStringAsFixed(1)}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
