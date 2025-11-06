import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/tracking_page.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  String? selectedCountry;
  bool saveAddress = false;
  int selectedCard = 0;
  int selectedPaymentMethod = 0; // 0 = Credit Card, 1 = Bank Transfer, 2 = VA

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context),
      drawer: const SideBar(),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _buildTabBar(),
          ),

          // Progress Indicator di bawah TabBar
          const SizedBox(height: 6),
          _buildProgressIndicator(),
          const SizedBox(height: 12),

          // Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildShippingTab(),
                _buildPaymentTab(),
                _buildCouponTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- APP BAR ----------
  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.black, size: 22),
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
    );
  }

  // ---------- TAB BAR ----------
  Widget _buildTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      indicatorColor: const Color(0xFF3A2D46),
      labelColor: const Color(0xFF3A2D46),
      unselectedLabelColor: const Color(0xFF9E9E9E),
      indicatorWeight: 2.5,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
        height: 1.1,
      ),
      tabs: const [
        Tab(text: "Shipping Address"),
        Tab(text: "Payment Method"),
        Tab(text: "Coupon Apply"),
      ],
    );
  }

  // ---------- PROGRESS INDICATOR ----------
  Widget _buildProgressIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final bool isActive = _tabController.index == index;
        return Row(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isActive ? const Color(0xFF3A2D46) : Colors.grey[300],
                shape: BoxShape.circle,
              ),
            ),
            if (index < 2)
              Container(
                width: 36,
                height: 2,
                margin: const EdgeInsets.symmetric(horizontal: 6),
                color: Colors.grey[300],
              ),
          ],
        );
      }),
    );
  }

  // ---------- SHIPPING TAB ----------
  Widget _buildShippingTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Card Holder Name"),
          _buildTextField(
            controller: TextEditingController(text: "Samuel Witwicky"),
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
          _buildDropdown(),
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
                onChanged: (val) => setState(() => saveAddress = val ?? false),
                activeColor: const Color(0xFF3A2D46),
              ),
              const Text("Save shipping address"),
            ],
          ),
          const SizedBox(height: 20),
          _buildNextButton(),
        ],
      ),
    );
  }

  // ---------- PAYMENT TAB ----------
  Widget _buildPaymentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRadioOption("Credit Card", 0),
          if (selectedPaymentMethod == 0)
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 28),
              child: _buildCreditCardSection(),
            ),

          _buildRadioOption("Bank Transfer", 1),
          if (selectedPaymentMethod == 1)
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 28),
              child: _buildBankTransferSection(),
            ),

          _buildRadioOption("Virtual Account", 2),
          if (selectedPaymentMethod == 2)
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 28),
              child: _buildVirtualAccountSection(),
            ),

          const Divider(),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Total Payment",
                style: TextStyle(fontWeight: FontWeight.w200, fontSize: 18),
              ),
              Text(
                "\$158.0",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Color(0xFF3A2D46),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildNextButton(),
        ],
      ),
    );
  }

  // ---------- COUPON TAB ----------
  Widget _buildCouponTab() {
    return SingleChildScrollView(
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
    );
  }

  // ---------- RADIO OPTION ----------
  Widget _buildRadioOption(String title, int index) {
    final bool isSelected = selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () => setState(() => selectedPaymentMethod = index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              margin: const EdgeInsets.only(right: 14),
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
                        width: 11,
                        height: 11,
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
                fontWeight: FontWeight.w600,
                fontSize: 16.5,
                color: isSelected ? const Color(0xFF3A2D46) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- CREDIT CARD SECTION ----------
  Widget _buildCreditCardSection() {
    final cards = [
      {
        "image": "assets/images/card/card1.png",
        "type": "Credit Card",
        "number": "1234 **** **** ****",
        "expiry": "04/25",
        "holder": "KEVIN HARD",
      },
      {
        "image": "assets/images/card/card2.png",
        "type": "MasterCard",
        "number": "5678 **** **** ****",
        "expiry": "04/25",
        "holder": "KEVIN HARD",
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
                          card["expiry"]!,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        Text(
                          card["holder"]!,
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

  // ---------- BANK TRANSFER ----------
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
        _buildDropdown(),
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

  // ---------- VIRTUAL ACCOUNT ----------
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

  // ---------- NEXT BUTTON ----------
  Widget _buildNextButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A384C),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        onPressed: () {
          // Custom order:
          // 1 (Payment) → 0 (Shipping) → 2 (Coupon) → TrackingPage
          if (_tabController.index == 1) {
            _tabController.animateTo(0);
          } else if (_tabController.index == 0) {
            _tabController.animateTo(2);
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TrackingPage()),
            );
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              "NEXT",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, size: 14, color: Colors.white),
          ],
        ),
      ),
    );
  }

  // ---------- HELPERS ----------
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6.0),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14.5),
    ),
  );

  Widget _buildTextField({
    required TextEditingController controller,
    String? hintText,
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

  Widget _buildDropdown() {
    return Container(
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
    );
  }
}
