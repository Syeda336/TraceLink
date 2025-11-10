import 'package:flutter/material.dart';

// --- Define the Color Palette ---
const Color primaryBlue = Color(0xFF42A5F5); // Bright Blue (Header, My Bubble)
const Color darkBlue = Color(
  0xFF1977D2,
); // Dark Blue (Body text, partner bubble text)
const Color lightBlueBackground = Color(
  0xFFE3F2FD,
); // Very Light Blue (Background)
const Color myBubbleColor = primaryBlue;
const Color partnerBubbleColor = lightBlueBackground;

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
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = []; // To store chat messages

  @override
  void initState() {
    super.initState();
    // Initialize with example messages
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

    // Add listener to automatically scroll to bottom when a new message is added
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  // Helper function to scroll to the bottom
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  // Clean up controllers
  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
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
      // Scroll to the latest message after sending
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    // ⚠️ CRITICAL: Get the height of the keyboard and system navigation bar
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      // ✅ MODIFICATION 1: Ensure Scaffold body resizes when keyboard pops up
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        // THEME CHANGE: AppBar background set to Primary Blue
        backgroundColor: primaryBlue,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ), // THEME CHANGE: Icon set to White
          onPressed: () {
            Navigator.pop(context); // Go back to MessagesListScreen
          },
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: widget.avatarColor.withOpacity(0.8),
              child: Text(
                widget.chatPartnerInitials,
                style: const TextStyle(
                  color: Colors.white,
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
                    color:
                        Colors.white, // THEME CHANGE: Partner name set to White
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.isOnline
                      ? 'Online'
                      : 'Offline', // Dynamically show online/offline
                  style: TextStyle(
                    color: Colors.white.withOpacity(
                      0.8,
                    ), // THEME CHANGE: Status text set to White
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: Colors.white,
            ), // THEME CHANGE: Icon set to White
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
              controller: _scrollController, // Use the scroll controller
              padding: const EdgeInsets.all(16.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _MessageBubble(
                  message: message['text'],
                  isMe: message['isMe'],
                  time: message['time'],
                  chatPartnerInitials: widget.chatPartnerInitials,
                  chatPartnerAvatarColor: widget.avatarColor,
                );
              },
            ),
          ),
          // Message Input Area
          // ✅ MODIFICATION 2: Remove fixed height and use Padding for responsiveness
          Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Container(
              // REMOVED fixed height: 150
              padding: const EdgeInsets.all(18.0),
              decoration: BoxDecoration(
                // THEME CHANGE: Input container color (White)
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment
                    .end, // Align contents to the bottom of the row
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color:
                            lightBlueBackground, // THEME CHANGE: Input field background
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: TextField(
                        controller: _messageController,
                        onSubmitted: (_) =>
                            _sendMessage(), // Allows sending on enter
                        // Added maxLines and minLines to allow the text field to grow vertically
                        minLines: 1,
                        maxLines: 5,
                        keyboardType: TextInputType.multiline,
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
                              color:
                                  darkBlue, // THEME CHANGE: Mic icon is Dark Blue
                            ),
                            onPressed: () {
                              // Voice message functionality
                            },
                          ),
                        ),
                        style: const TextStyle(
                          color: darkBlue,
                        ), // THEME CHANGE: Typed text color
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      // THEME CHANGE: Send button uses Primary Blue solid color
                      color: primaryBlue,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
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

// MessageBubble class remains unchanged as it doesn't affect keyboard handling
class _MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String time;
  final String? chatPartnerInitials;
  final Color? chatPartnerAvatarColor;

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

    // THEME CHANGE: My bubble is Primary Blue, Partner bubble is Light Blue
    final backgroundColor = isMe ? myBubbleColor : partnerBubbleColor;

    // THEME CHANGE: My text is White, Partner text is Dark Blue
    final textColor = isMe ? Colors.white : darkBlue;

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
              // Avatar for received messages
              if (!isMe &&
                  chatPartnerInitials != null &&
                  chatPartnerAvatarColor != null)
                CircleAvatar(
                  radius: 16,
                  // Use a slightly darker color for better contrast
                  backgroundColor: chatPartnerAvatarColor!.withOpacity(0.8),
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
              right: isMe ? 40.0 : 0, // Adjusted right padding for my messages
            ),
            child: Text(
              time,
              // THEME CHANGE: Time text is Dark Blue (slightly muted)
              style: TextStyle(color: darkBlue.withOpacity(0.6), fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
