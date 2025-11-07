import 'package:flutter/material.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/tracking_page.dart';

class StoreLocationsPage extends StatefulWidget {
  const StoreLocationsPage({super.key});

  @override
  State<StoreLocationsPage> createState() => _StoreLocationsPageState();
}

class _StoreLocationsPageState extends State<StoreLocationsPage> {
  bool isMapView = true;

  // 🔹 Scaffold Key untuk buka Sidebar
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey, // penting untuk akses drawer
      drawer: const SideBar(), // Sidebar kamu
      appBar: AppBar(
        title: const Text(
          "Store Locations",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.8,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                _scaffoldKey.currentState?.openDrawer(); // 👈 buka sidebar
              },
              child: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          // 🔹 TOGGLE LIST / MAP
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMapView = false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: !isMapView ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "List View",
                        style: TextStyle(
                          color: !isMapView ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => isMapView = true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isMapView ? Colors.white : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "Map View",
                        style: TextStyle(
                          color: isMapView ? Colors.black : Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ MODE VIEW
          Expanded(child: isMapView ? _buildMapView() : _buildListView()),
        ],
      ),
    );
  }

  // ✅ LIST VIEW MODE
  Widget _buildListView() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        StoreListItem(
          title: "Medan Plaza",
          time: "09:00 AM - 10:00 PM",
          distance: "3,5 Km",
          imagePath: "assets/images/store/str1.jpg",
        ),
        SizedBox(height: 16),
        StoreListItem(
          title: "Center Point",
          time: "09:00 AM - 10:00 PM",
          distance: "7,5 Km",
          imagePath: "assets/images/store/str2.jpg",
        ),
        SizedBox(height: 16),
        StoreListItem(
          title: "Coffe Shope",
          time: "09:00 AM - 10:00 PM",
          distance: "3,5 Km",
          imagePath: "assets/images/store/str3.jpg",
        ),
        SizedBox(height: 16),
        StoreListItem(
          title: "Medan Plaza",
          time: "09:00 AM - 10:00 PM",
          distance: "3,5 Km",
          imagePath: "assets/images/store/str4.jpg",
        ),
      ],
    );
  }

  // ✅ MAP VIEW MODE
  Widget _buildMapView() {
    return Stack(
      children: [
        // 🗺 background
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background/map.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        // 🏪 horizontal cards
        Positioned(
          bottom: 20,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                _StoreCard(
                  outletName: "Outlet 01",
                  title: "Medan Plaza",
                  time: "09:00 AM - 10:00 PM",
                  distance: "3,5 Km",
                  imagePath: "assets/images/store/str1.jpg",
                  avatars: [
                    "assets/images/avatar/1.jpg",
                    "assets/images/avatar/2.jpg",
                    "assets/images/avatar/3.jpg",
                  ],
                ),
                SizedBox(width: 12),
                _StoreCard(
                  outletName: "Outlet 02",
                  title: "Center Point",
                  time: "09:00 AM - 10:00 PM",
                  distance: "7,5 Km",
                  imagePath: "assets/images/store/str2.jpg",
                  avatars: [
                    "assets/images/avatar/4.jpg",
                    "assets/images/avatar/5.jpg",
                    "assets/images/avatar/1.jpg",
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ✅ LIST VIEW ITEM COMPONENT
class StoreListItem extends StatelessWidget {
  final String title;
  final String time;
  final String distance;
  final String imagePath;

  const StoreListItem({
    super.key,
    required this.title,
    required this.time,
    required this.distance,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 👇 Navigasi ke TrackingPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackingPage()),
        );
      },
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
              child: Image.asset(
                imagePath,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      time,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: Colors.black,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          distance,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ✅ StoreCard untuk MAP VIEW
class _StoreCard extends StatelessWidget {
  final String outletName;
  final String title;
  final String time;
  final String distance;
  final String imagePath;
  final List<String> avatars;

  const _StoreCard({
    required this.outletName,
    required this.title,
    required this.time,
    required this.distance,
    required this.imagePath,
    required this.avatars,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 👇 Navigasi ke TrackingPage
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TrackingPage()),
        );
      },
      child: Container(
        width: 220,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade300,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      outletName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    time,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        distance,
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      for (var avatar in avatars) ...[
                        CircleAvatar(
                          radius: 10,
                          backgroundImage: AssetImage(avatar),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
