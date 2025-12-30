import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/message_dm_page.dart';
import 'package:project_kuliah_mwsp_uts_kel4/components/sidebar.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  // ================= LIST USER / KONTAK =================
  final List<Map<String, dynamic>> messages = [
    {
      "id": 1,
      "name": "Sam Verdinand",
      "role": "Kurir",
      "lastMessage": "Mohon ditunggu sebentar ya",
      "time": "2M AGO",
      "image": "assets/images/avatar/1.jpg",
      "online": true,
    },
    {
      "id": 2,
      "name": "Freddie Ronan",
      "role": "Admin",
      "lastMessage": "Baik, terimakasih informasinya.",
      "time": "2:00 PM",
      "image": "assets/images/avatar/2.jpg",
      "online": true,
    },
    {
      "id": 3,
      "name": "Ethan Jacoby",
      "role": "Kurir",
      "lastMessage": "Saya segera kesana, mohon ditunggu",
      "time": "5:00 PM",
      "image": "assets/images/avatar/3.jpg",
      "online": true,
    },
    {
      "id": 4,
      "name": "Alfie Mason",
      "role": "Kurir",
      "lastMessage": "Mohon ditunggu sebentar",
      "time": "3:00 AM",
      "image": "assets/images/avatar/4.jpg",
      "online": false,
    },
    {
      "id": 5,
      "name": "Archie Parker",
      "role": "Kurir",
      "lastMessage": "Makanan sedang saya pickup",
      "time": "TODAY",
      "image": "assets/images/avatar/5.jpg",
      "online": false,
    },
  ];

  // ================= CHAT AWAL PER USER =================
  final Map<int, List<Map<String, dynamic>>> chatData = {
    1: [
      {
        "text": "Mohon ditunggu sebentar ya",
        "isSent": false,
        "time": "12:58",
        "date": "Sunday, Feb 9",
      },
      {"text": "Baik pak, saya tunggu.", "isSent": true},
    ],
    2: [
      {
        "text": "Pesanan anda sudah kami konfirmasi.",
        "isSent": false,
        "time": "13:00",
        "date": "Sunday, Feb 9",
      },
      {"text": "Terima kasih admin.", "isSent": true},
    ],
    3: [
      {
        "text": "Saya segera kesana, mohon ditunggu",
        "isSent": false,
        "time": "14:00",
        "date": "Sunday, Feb 9",
      },
      {"text": "Baik, saya tunggu.", "isSent": true},
    ],
    4: [
      {
        "text": "Mohon ditunggu sebentar ya kak",
        "isSent": false,
        "time": "03:00",
        "date": "Monday, Feb 10",
      },
      {"text": "Baik, saya tunggu.", "isSent": true},
    ],
    5: [
      {
        "text": "Makanan sedang saya pickup",
        "isSent": false,
        "time": "10:30",
        "date": "Today",
      },
      {"text": "Siap, ditunggu ya.", "isSent": true},
    ],
  };

  @override
  Widget build(BuildContext context) {
    final filteredMessages = messages
        .where(
          (msg) =>
              msg["name"].toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,

      // ===== SIDEBAR =====
      drawer: const SideBar(),

      // ===== APPBAR (FIXED) =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.4,
        centerTitle: true,

        automaticallyImplyLeading: false,

        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),

        title: const Text(
          "Messages List",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),

        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black87),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
        ],
      ),

      // ===== BODY =====
      body: Column(
        children: [
          // SEARCH BAR
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFEBEBEB)),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/svg/icons/search_icon.svg',
                    width: 20,
                    height: 20,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => searchQuery = val),
                      decoration: const InputDecoration(
                        hintText: "Search messages...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // CHAT LIST
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredMessages.length,
              itemBuilder: (context, index) {
                final msg = filteredMessages[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MessageDmPage(
                          userId: msg["id"],
                          userName: msg["name"],
                          role: msg["role"],
                          avatar: msg["image"],
                          initialMessages: chatData[msg["id"]] ?? [],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    child: Row(
                      children: [
                        // AVATAR
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.asset(
                                msg["image"],
                                width: 55,
                                height: 55,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (msg["online"])
                              Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  width: 10,
                                  height: 10,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // INFO
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    msg["name"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    msg["time"],
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                msg["lastMessage"],
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
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
          ),
        ],
      ),
    );
  }
}
