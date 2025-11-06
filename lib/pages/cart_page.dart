import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';
import 'checkout_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

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
      "status": "all",
    },
    {
      "title": "Hot Sweet Indonesian Tea",
      "price": 5.8,
      "qty": 2,
      "image": "assets/images/cart/pic3.jpg",
      "status": "all",
    },
    {
      "title": "Caramel Latte Classic",
      "price": 7.5,
      "qty": 1,
      "image": "assets/images/cart/pic4.jpg",
      "status": "all",
    },
    {
      "title": "Espresso Bold Roast",
      "price": 6.2,
      "qty": 1,
      "image": "assets/images/cart/pic1.jpg",
      "status": "delivery",
    },
    {
      "title": "Cold Brew Signature",
      "price": 8.4,
      "qty": 2,
      "image": "assets/images/cart/pic2.jpg",
      "status": "delivery",
    },
    {
      "title": "Matcha Latte Creamy",
      "price": 9.8,
      "qty": 1,
      "image": "assets/images/cart/pic3.jpg",
      "status": "done",
    },
    {
      "title": "Hazelnut Iced Coffee",
      "price": 10.2,
      "qty": 1,
      "image": "assets/images/cart/pic4.jpg",
      "status": "done",
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
      bool matchesTab = status == "all"
          ? item["status"] == "all"
          : item["status"] == status;
      return matchesSearch && matchesTab;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(), // ✅ Tambahkan sidebar di sini
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Builder(
          builder: (context) => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 🔹 Tombol Back
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 26,
                ),
              ),

              // 🔹 Judul Cart di tengah
              const Text(
                "Cart",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),

              // 🔹 Ikon titik tiga di kanan untuk buka sidebar
              GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: const Icon(
                  Icons.more_vert,
                  color: Colors.black,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
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

          // 🔹 List isi keranjang + note
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                buildCartListWithNote("all"),
                buildCartListWithNote("delivery"),
                buildCartListWithNote("done"),
              ],
            ),
          ),
        ],
      ),

      // 🔹 Tombol “Place Order”
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CheckoutPage()),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3A2D46),
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

  Widget buildCartListWithNote(String status) {
    var items = getFilteredItems(status);

    if (items.isEmpty) {
      return const Center(child: Text("Nothing found"));
    }

    return ListView.separated(
      itemCount: items.length + 1,
      separatorBuilder: (context, index) => index < items.length
          ? const Divider(color: Color(0xFFE0E0E0), height: 1)
          : const SizedBox.shrink(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Padding(
            padding: const EdgeInsets.only(top: 8, left: 4),
            child: RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Note: ",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(
                    text: "-Swipe to delete Cart Items",
                    style: TextStyle(
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

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
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset(
                    item["image"],
                    width: 95,
                    height: 95,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item["title"],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\$${item["price"]}",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            "${item["qty"]}x",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
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
                    ],
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
