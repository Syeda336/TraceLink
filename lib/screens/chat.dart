// chat_screen.dart
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String chatPartnerName;
  final String chatPartnerInitials;
  final bool isOnline;
  final Color avatarColor;

  const ChatScreen({
    super.key,
    required this.chatPartnerName,
    required this.chatPartnerInitials,
    this.isOnline = false,
    required this.avatarColor,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // To store chat messages

  @override
  void initState() {
    super.initState();
    // Initialize with example messages from Image 2
    _messages.add({
      'text': 'Hi! I found your wallet at the library',
      'isMe': false,
      'time': '10:30 AM',
    });
    _messages.add({
      'text': 'Oh thank you so much! Where exactly did you find it?',
      'isMe': true,
      'time': '10:32 AM',
    });
    _messages.add({
      'text':
          'It was on the table near study room 12. I turned it in to the front desk.',
      'isMe': false,
      'time': '10:33 AM',
    });
    _messages.add({
      'text': 'Perfect! I can pick it up today. Thank you again!',
      'isMe': true,
      'time': '10:35 AM',
    });
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add({
          'text': _messageController.text.trim(),
          'isMe': true, // Assume current user is sending the message
          'time': TimeOfDay.now().format(context), // Current time
        });
      });
      _messageController.clear();
      // In a real app, you would send this message to a backend
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Light background for app bar
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // Go back to MessagesListScreen
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: widget.avatarColor,
              child: Text(
                widget.chatPartnerInitials,
                style: const TextStyle(
                  color: Colors.white, // Initials color inside avatar
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.chatPartnerName,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.isOnline
                      ? 'Online'
                      : 'Offline', // Dynamically show online/offline
                  style: TextStyle(
                    color: widget.isOnline ? Colors.green : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(
                  message: message['text'],
                  isMe: message['isMe'],
                  time: message['time'],
                  chatPartnerInitials:
                      widget.chatPartnerInitials, // Pass for received messages
                  chatPartnerAvatarColor:
                      widget.avatarColor, // Pass for received messages
                );
              },
            ),
          ),
          // Message Input Area
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.mic,
                            color: Color(0xFF9932CC),
                          ), // Purple mic icon
                          onPressed: () {
                            // Voice message functionality
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFCC2B5E),
                        Color(0xFF753A88),
                      ], // Pink to Purple gradient
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(24), // Circular button
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String? chatPartnerInitials; // Only for received messages
  final Color? chatPartnerAvatarColor; // Only for received messages

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.time,
    this.chatPartnerInitials,
    this.chatPartnerAvatarColor,
  });

  @override
  Widget build(BuildContext context) {
    // Determine alignment based on who sent the message
    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final backgroundColor = isMe
        ? const Color(0xFFCC2B5E)
        : Colors.grey.shade100; // Pink for me, light grey for others
    final textColor = isMe ? Colors.white : Colors.black;
    final borderRadius = BorderRadius.circular(15);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          Row(
            mainAxisAlignment: isMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isMe &&
                  chatPartnerInitials != null &&
                  chatPartnerAvatarColor != null)
                CircleAvatar(
                  radius: 16,
                  backgroundColor:
                      chatPartnerAvatarColor, // Use actual avatar color
                  child: Text(
                    chatPartnerInitials!,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              if (!isMe)
                const SizedBox(width: 8), // Spacing for received message avatar
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10.0,
                  ),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: isMe
                        ? borderRadius.copyWith(bottomRight: Radius.zero)
                        : borderRadius.copyWith(bottomLeft: Radius.zero),
                  ),
                  child: Text(
                    message,
                    style: TextStyle(color: textColor, fontSize: 15),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(
              left: isMe ? 0 : 40.0,
              right: isMe ? 0 : 40.0,
            ), // Adjust for avatar
            child: Text(
              time,
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
