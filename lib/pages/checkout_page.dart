import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final TextEditingController nameController = TextEditingController(
    text: "Samuel Witwicky",
  );

  String? selectedCountry;
  bool saveAddress = false;
  int selectedCard = 0;
  int selectedPaymentMethod = 0; // 0 = Credit Card, 1 = Bank Transfer, 2 = VA

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    selectedPaymentMethod = 0; // Default Credit Card
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
                size: 22,
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ],
        ),
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

      // ---------------- BODY ----------------
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: const Color(0xFF3A2D46),
              labelColor: const Color(0xFF3A2D46),
              unselectedLabelColor: const Color(0xFF9E9E9E),
              indicatorWeight: 2.5,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
                height: 1.1,
              ),
              tabs: const [
                Tab(text: "Payment Method"),
                Tab(text: "Shipping Address"),
                Tab(text: "Coupon Apply"),
              ],
            ),
          ),

          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // ---------------- PAYMENT METHOD ----------------
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Payment Method",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      _buildRadioOption("Credit Card", 0),
                      if (selectedPaymentMethod == 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildCreditCardSection(),
                        ),

                      const SizedBox(height: 12),
                      _buildRadioOption("Bank Transfer", 1),
                      if (selectedPaymentMethod == 1)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildBankTransferSection(),
                        ),

                      const SizedBox(height: 12),
                      _buildRadioOption("Virtual Account", 2),
                      if (selectedPaymentMethod == 2)
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildVirtualAccountSection(),
                        ),

                      const SizedBox(height: 24),
                      const Divider(),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Total Payment",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            "\$158.0",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF3A2D46),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      _buildNextButton(),
                    ],
                  ),
                ),

                // ---------------- SHIPPING ADDRESS ----------------
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Card Holder Name"),
                      _buildTextField(
                        controller: TextEditingController(
                          text: "Samuel Witwicky",
                        ),
                        hintText: "Your Name",
                      ),
                      const SizedBox(height: 12),
                      _buildLabel("Zip/postal Code"),
                      _buildTextField(
                        controller: TextEditingController(),
                        hintText: "Enter code",
                      ),
                      const SizedBox(height: 12),
                      _buildLabel("Country"),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedCountry,
                            hint: const Text(
                              "Choose your country",
                              style: TextStyle(color: Colors.grey),
                            ),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: "USA",
                                child: Text("USA"),
                              ),
                              DropdownMenuItem(
                                value: "China",
                                child: Text("China"),
                              ),
                              DropdownMenuItem(
                                value: "India",
                                child: Text("India"),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => selectedCountry = value),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildLabel("State"),
                      _buildTextField(
                        controller: TextEditingController(),
                        hintText: "Enter here",
                      ),
                      const SizedBox(height: 12),
                      _buildLabel("City"),
                      _buildTextField(
                        controller: TextEditingController(),
                        hintText: "Enter here",
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Checkbox(
                            value: saveAddress,
                            onChanged: (val) =>
                                setState(() => saveAddress = val ?? false),
                            activeColor: const Color(0xFF3A2D46),
                          ),
                          const Text("Save shipping address"),
                        ],
                      ),
                      const SizedBox(height: 20),
                      _buildNextButton(),
                    ],
                  ),
                ),

                // ---------------- COUPON APPLY ----------------
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel("Enter Coupon Code"),
                      _buildTextField(
                        controller: TextEditingController(text: "#54856913215"),
                        hintText: "Enter Coupon Code",
                      ),
                      const SizedBox(height: 20),
                      _buildNextButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Radio Option ----------
  Widget _buildRadioOption(String title, int index) {
    final bool isSelected = selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = index),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? const Color(0xFF3A2D46) : Colors.grey,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3A2D46),
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                : null,
          ),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF3A2D46) : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Credit Card Section ----------
  Widget _buildCreditCardSection() {
    final cards = [
      {
        "image": "assets/images/card/card1.png",
        "type": "Visa",
        "number": "**** **** **** 1234",
        "holder": "Samuel Witwicky",
        "expiry": "12/26",
      },
      {
        "image": "assets/images/card/card2.png",
        "type": "MasterCard",
        "number": "**** **** **** 5678",
        "holder": "John Connor",
        "expiry": "09/27",
      },
    ];

    return SizedBox(
      height: 190,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        itemBuilder: (context, index) {
          final card = cards[index];
          final bool active = selectedCard == index;

          return GestureDetector(
            onTap: () => setState(() => selectedCard = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 16),
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: active ? const Color(0xFF3A2D46) : Colors.transparent,
                  width: 2,
                ),
                image: DecorationImage(
                  image: AssetImage(card["image"]!),
                  fit: BoxFit.cover,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade400,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      card["type"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      card["number"]!,
                      style: const TextStyle(
                        color: Colors.white,
                        letterSpacing: 2,
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          card["holder"]!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          card["expiry"]!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---------- Bank Transfer Section ----------
  Widget _buildBankTransferSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Card Holder Name"),
        _buildTextField(
          controller: TextEditingController(text: "Samuel Witwicky"),
          hintText: "Your Name",
        ),
        const SizedBox(height: 12),
        _buildLabel("Card Number"),
        _buildTextField(
          controller: TextEditingController(text: "1234 5678 9101 1121"),
          keyboardType: TextInputType.number,
          hintText: "Enter Number",
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Month/Year"),
                  _buildTextField(
                    controller: TextEditingController(),
                    hintText: "Enter here",
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("CVV"),
                  _buildTextField(
                    controller: TextEditingController(),
                    hintText: "Enter here",
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildLabel("Country"),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedCountry,
              hint: const Text(
                "Choose your country",
                style: TextStyle(color: Colors.grey),
              ),
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: "USA", child: Text("USA")),
                DropdownMenuItem(value: "China", child: Text("China")),
                DropdownMenuItem(value: "India", child: Text("India")),
              ],
              onChanged: (value) => setState(() => selectedCountry = value),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Checkbox(
              value: saveAddress,
              onChanged: (val) => setState(() => saveAddress = val ?? false),
              activeColor: const Color(0xFF3A2D46),
            ),
            const Text("Save shipping address"),
          ],
        ),
      ],
    );
  }

  // ---------- Virtual Account Section ----------
  Widget _buildVirtualAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel("Card Holder Name"),
        _buildTextField(
          controller: TextEditingController(text: "Samuel Witwicky"),
          hintText: "Your Name",
        ),
        const SizedBox(height: 12),
        _buildLabel("Card Number"),
        _buildTextField(
          controller: TextEditingController(text: "1234 5678 9101 1121"),
          keyboardType: TextInputType.number,
          hintText: "Enter Number",
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("Month/Year"),
                  _buildTextField(
                    controller: TextEditingController(),
                    hintText: "Enter here",
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel("CVV"),
                  _buildTextField(
                    controller: TextEditingController(),
                    hintText: "Enter here",
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------- Button ----------
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3A2D46),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          if (_tabController.index < 2) {
            _tabController.animateTo(_tabController.index + 1);
          }
        },
        child: const Text(
          "Next",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  // ---------- Helpers ----------
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 14.0,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
