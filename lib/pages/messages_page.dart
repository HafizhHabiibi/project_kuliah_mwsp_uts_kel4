import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../components/sidebar.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import 'message_dm_page.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  final TextEditingController _searchController = TextEditingController();
  String searchQuery = '';

  late Future<List<dynamic>> _chatsFuture;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    final token = await AuthService.getToken();
    setState(() {
      _chatsFuture = ChatService.getChats(token!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: const SideBar(),

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

      body: Column(
        children: [
          // ===== SEARCH BAR =====
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
                      onChanged: (val) {
                        setState(() => searchQuery = val);
                      },
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

          // ===== CHAT LIST =====
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _chatsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Gagal memuat chat'));
                }

                final chats = snapshot.data ?? [];

                final filteredChats = chats.where((chat) {
                  final courierName = (chat['courier']['name'] ?? '')
                      .toString()
                      .toLowerCase();
                  return courierName.contains(searchQuery.toLowerCase());
                }).toList();

                if (filteredChats.isEmpty) {
                  return const Center(child: Text('Tidak ada chat'));
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredChats.length,
                  itemBuilder: (context, index) {
                    final chat = filteredChats[index];
                    final courier = chat['courier'];
                    final lastMessage = chat['last_message'];

                    return GestureDetector(
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MessageDmPage(
                              chatId: chat['id'],
                              courierName: courier['name'] ?? 'Kurir',
                              courierAvatar: courier['avatar_url'],
                            ),
                          ),
                        );

                        // reload setelah balik dari DM
                        _loadChats();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            // ===== AVATAR =====
                            Stack(
                              children: [
                                CircleAvatar(
                                  radius: 28,
                                  backgroundImage: courier['avatar_url'] != null
                                      ? NetworkImage(courier['avatar_url'])
                                      : null,
                                  child: courier['avatar_url'] == null
                                      ? const Icon(Icons.delivery_dining)
                                      : null,
                                ),
                                if (courier['is_online'] == true)
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

                            // ===== INFO =====
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        courier['name'] ?? 'Kurir',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        courier['is_online'] == true
                                            ? 'ONLINE'
                                            : 'OFFLINE',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    lastMessage != null
                                        ? lastMessage['message']
                                        : 'Belum ada pesan',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
