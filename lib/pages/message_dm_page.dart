import 'package:flutter/material.dart';
import '../components/sidebar.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';

class MessageDmPage extends StatefulWidget {
  final int chatId;
  final String courierName;
  final String? courierAvatar;

  const MessageDmPage({
    super.key,
    required this.chatId,
    required this.courierName,
    this.courierAvatar,
  });

  @override
  State<MessageDmPage> createState() => _MessageDmPageState();
}

class _MessageDmPageState extends State<MessageDmPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late Future<List<dynamic>> _messagesFuture;

  @override
  void initState() {
    super.initState();
    _messagesFuture = _loadMessages();
  }

  Future<List<dynamic>> _loadMessages() async {
    final token = await AuthService.getToken();
    return ChatService.getMessages(widget.chatId, token!);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final token = await AuthService.getToken();

    await ChatService.sendMessage(
      widget.chatId,
      _messageController.text.trim(),
      token!,
    );

    _messageController.clear();

    setState(() {
      _messagesFuture = _loadMessages();
    });

    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      // ===== SIDEBAR =====
      drawer: const SideBar(),

      // ===== APPBAR =====
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 21,
              backgroundImage: widget.courierAvatar != null
                  ? NetworkImage(widget.courierAvatar!)
                  : null,
              child: widget.courierAvatar == null
                  ? const Icon(Icons.delivery_dining)
                  : null,
            ),
            const SizedBox(width: 10),
            Text(
              widget.courierName,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
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
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: _messagesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Gagal memuat pesan'));
                }

                final messages = snapshot.data ?? [];

                if (messages.isEmpty) {
                  return const Center(child: Text('Belum ada pesan'));
                }

                return ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final bool isUser = msg['sender'] == 'user';

                    return Align(
                      alignment: isUser
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        constraints: const BoxConstraints(maxWidth: 280),
                        decoration: BoxDecoration(
                          color: isUser
                              ? const Color(0xFF4A3749)
                              : const Color(0xFFE1CFA7),
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(22),
                            topRight: Radius.circular(isUser ? 0 : 22),
                            bottomLeft: Radius.circular(isUser ? 22 : 0),
                            bottomRight: const Radius.circular(22),
                          ),
                        ),
                        child: Text(
                          msg['message'],
                          style: TextStyle(
                            color: isUser
                                ? Colors.white
                                : const Color(0xFF262626),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // ===== INPUT =====
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      minLines: 1,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
