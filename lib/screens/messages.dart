// messages_list.dart
import 'package:flutter/material.dart';
import 'home.dart'; // Import the hypothetical Home.dart screen
import 'chat.dart'; // Import the ChatScreen

class MessagesListScreen extends StatelessWidget {
  const MessagesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The background color of the app bar seems to be the light background of the screen
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Functionality to open home.dart
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          },
        ),
        title: const Text(
          'Messages',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              children: const [
                // Sarah Johnson Conversation (Image 1)
                _ConversationListItem(
                  userInitials: 'SJ',
                  userName: 'Sarah Johnson',
                  lastMessage: 'Yes, I still have the keys with me',
                  timeAgo: '2m ago',
                  unreadCount: 2,
                  isOnline: true,
                  avatarColor: Color(0xFFC8A2C8), // Purple/Pinkish for SJ
                  initialsColor: Color(0xFF9932CC),
                ),
                Divider(height: 1),
                // Mike Chen Conversation (Image 1)
                _ConversationListItem(
                  userInitials: 'MC',
                  userName: 'Mike Chen',
                  lastMessage: 'Can we meet at the library?',
                  timeAgo: '1h ago',
                  unreadCount: 0,
                  isOnline: false,
                  avatarColor: Color(0xFFF1948A), // Pinkish for MC
                  initialsColor: Color(0xFFE57373),
                ),
                Divider(height: 1),
                // Emma Wilson Conversation (Image 1)
                _ConversationListItem(
                  userInitials: 'EW',
                  userName: 'Emma Wilson',
                  lastMessage: 'Thank you so much for finding ...',
                  timeAgo: '3h ago',
                  unreadCount: 1,
                  isOnline: true,
                  avatarColor: Color(0xFFF0F8FF), // Light blue for EW
                  initialsColor: Color(0xFFDA70D6),
                ),
                Divider(height: 1),
                // Alex Brown Conversation (Image 1)
                _ConversationListItem(
                  userInitials: 'AB',
                  userName: 'Alex Brown',
                  lastMessage: 'Is this the blue backpack?',
                  timeAgo: '1d ago',
                  unreadCount: 0,
                  isOnline: false,
                  avatarColor: Color(0xFFDDA0DD), // Plum for AB
                  initialsColor: Color(0xFFBA55D3),
                ),
                Divider(height: 1),
                // Additional conversations to fill the screen if needed
                _ConversationListItem(
                  userInitials: 'JR',
                  userName: 'John Ryan',
                  lastMessage: 'Sounds good, thanks!',
                  timeAgo: '2d ago',
                  unreadCount: 0,
                  isOnline: false,
                  avatarColor: Color(0xFF90EE90),
                  initialsColor: Color(0xFF3CB371),
                ),
                Divider(height: 1),
                _ConversationListItem(
                  userInitials: 'KP',
                  userName: 'Kate Perry',
                  lastMessage: 'I found your glasses!',
                  timeAgo: '3d ago',
                  unreadCount: 3,
                  isOnline: true,
                  avatarColor: Color(0xFFFFD700),
                  initialsColor: Color(0xFFDAA520),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ConversationListItem extends StatelessWidget {
  final String userInitials;
  final String userName;
  final String lastMessage;
  final String timeAgo;
  final int unreadCount;
  final bool isOnline;
  final Color avatarColor;
  final Color initialsColor;

  const _ConversationListItem({
    required this.userInitials,
    required this.userName,
    required this.lastMessage,
    required this.timeAgo,
    required this.unreadCount,
    required this.isOnline,
    required this.avatarColor,
    required this.initialsColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // When clicking on a message, navigate to the ChatScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              chatPartnerName: userName,
              chatPartnerInitials: userInitials,
              isOnline: isOnline,
              avatarColor: avatarColor,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: avatarColor,
                  child: Text(
                    userInitials,
                    style: TextStyle(
                      color: initialsColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lastMessage,
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeAgo,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (unreadCount > 0) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9932CC), // Purple count bubble
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      unreadCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
