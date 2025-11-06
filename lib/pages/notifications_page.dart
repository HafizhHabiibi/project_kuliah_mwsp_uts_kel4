import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_kuliah_mwsp_uts_kel4/pages/profile_page.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> notifications = [
      {
        "title": "Apply Success",
        "text": "You have applied for a job in Queenify Group as UI Designer",
        "time": "10h ago",
        "status": "success",
      },
      {
        "title": "Interview Calls",
        "text": "Congratulations! You have interview calls",
        "time": "9h ago",
        "status": "success",
      },
      {
        "title": "Apply Success",
        "text": "You have applied for a job in Queenify Group as UI Designer",
        "time": "8h ago",
        "status": "normal",
      },
      {
        "title": "Complete your profile",
        "text":
            "Please verify your profile information to continue using this app",
        "time": "4h ago",
        "status": "normal",
      },
      {
        "title": "Apply Success",
        "text": "You have applied for a job in Queenify Group as UI Designer",
        "time": "10h ago",
        "status": "normal",
      },
      {
        "title": "Interview Calls",
        "text": "Congratulations! You have interview calls",
        "time": "9h ago",
        "status": "normal",
      },
      {
        "title": "Apply Success",
        "text": "You have applied for a job in Queenify Group as UI Designer",
        "time": "8h ago",
        "status": "normal",
      },
      {
        "title": "Complete your profile",
        "text":
            "Please verify your profile information to continue using this app",
        "time": "4h ago",
        "status": "normal",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Notifications",
          style: TextStyle(
            color: Color(0xFF222222),
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              'assets/images/svg/icons/profile_icon.svg',
              width: 24,
              height: 24,
              color: const Color(0xFF222222),
            ),
            // 👉 Saat ditekan, pindah ke halaman profil
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: ListView.builder(
          itemCount: notifications.length,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final notif = notifications[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🔵 Icon status
                  notif["status"] == "success"
                      ? Container(
                          margin: const EdgeInsets.only(right: 12, top: 2),
                          child: const Icon(
                            Icons.circle,
                            size: 12,
                            color: Color.fromARGB(255, 55, 183, 175),
                          ),
                        )
                      : const SizedBox.shrink(),

                  // 🧾 Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title + Time
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                notif["title"]!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Row(
                              children: [
                                const SizedBox(width: 4),
                                Text(
                                  notif["time"]!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        // Body text
                        Text(
                          notif["text"]!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
