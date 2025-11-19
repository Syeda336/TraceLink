import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracelink/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_service.dart';

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

// --- Define Dark Theme Colors (New) ---
const Color darkBackgroundColor = Color(0xFF121212); // Deep Dark
const Color darkSurfaceColor = Color(0xFF1E1E1E); // Darker surface
const Color darkPrimaryColor = Color(0xFF90CAF9); // Light Blue for accents
const Color darkTextColor = Colors.white;
const Color darkHintColor = Color(0xFFB0B0B0); // Light Grey for hints

class ChatScreen extends StatefulWidget {
  final String chatPartnerName;
  final String chatPartnerInitials;
  final bool isOnline;
  final Color avatarColor;
  final String? receiverId; // Add receiver ID for Firebase

  const ChatScreen({
    super.key,
    required this.chatPartnerName,
    required this.chatPartnerInitials,
    this.isOnline = false,
    required this.avatarColor,
    this.receiverId, // Make it optional for backward compatibility
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, dynamic>> _messages = []; // To store chat messages
  Stream<QuerySnapshot>? _messagesStream;
  bool _isLoading = true;
  bool _useFirebase = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  void _initializeChat() async {
    // Check if we have a receiver ID for Firebase
    if (widget.receiverId != null && widget.receiverId!.isNotEmpty) {
      try {
        _useFirebase = true;
        _messagesStream = FirebaseService.getMessages(widget.receiverId!);

        // Mark messages as read when opening chat
        await FirebaseService.markMessagesAsRead(widget.receiverId!);
      } catch (e) {
        print('Error initializing Firebase chat: $e');
        _useFirebase = false;
        _loadHardcodedMessages();
      }
    } else {
      _useFirebase = false;
      _loadHardcodedMessages();
    }

    setState(() {
      _isLoading = false;
    });

    // Scroll to bottom after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _loadHardcodedMessages() {
    // Initialize with example messages (only if not using Firebase)
    _messages.addAll([
      {
        'text': 'Hi! I found your wallet at the library',
        'isMe': false,
        'time': '10:30 AM',
        'senderId': 'partner',
      },
      {
        'text': 'Oh thank you so much! Where exactly did you find it?',
        'isMe': true,
        'time': '10:32 AM',
        'senderId': 'current',
      },
      {
        'text':
            'It was on the table near study room 12. I turned it in to the front desk.',
        'isMe': false,
        'time': '10:33 AM',
        'senderId': 'partner',
      },
      {
        'text': 'Perfect! I can pick it up today. Thank you again!',
        'isMe': true,
        'time': '10:35 AM',
        'senderId': 'current',
      },
    ]);
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

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();
    final currentTime = TimeOfDay.now().format(context);

    if (_useFirebase && widget.receiverId != null) {
      // Send message via Firebase
      bool success = await FirebaseService.sendMessage(
        receiverId: widget.receiverId!,
        message: messageText,
        receiverName: widget.chatPartnerName,
        receiverInitials: widget.chatPartnerInitials,
      );

      if (success) {
        _messageController.clear();
      } else {
        // Fallback: add to local list if Firebase fails
        _addMessageToLocalList(messageText, true, currentTime);
      }
    } else {
      // Use local messages
      _addMessageToLocalList(messageText, true, currentTime);
    }
  }

  void _addMessageToLocalList(String text, bool isMe, String time) {
    setState(() {
      _messages.add({
        'text': text,
        'isMe': isMe,
        'time': time,
        'senderId': isMe ? 'current' : 'partner',
      });
    });
    _messageController.clear();
    _scrollToBottom();
  }

  // Convert Firebase document to message format
  Map<String, dynamic> _firebaseDocToMessage(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    final isMe = data['senderId'] == currentUserId;

    // Format timestamp
    String time = '10:00 AM'; // Default
    if (data['timestamp'] != null) {
      final timestamp = data['timestamp'] as Timestamp;
      final dateTime = timestamp.toDate();
      time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    return {
      'text': data['message'] ?? '',
      'isMe': isMe,
      'time': time,
      'senderId': data['senderId'],
    };
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkSurfaceColor : primaryBlue,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.isOnline ? 'Online' : 'Offline',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // More options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _useFirebase
                ? StreamBuilder<QuerySnapshot>(
                    stream: _messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final messages = snapshot.data!.docs;
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = _firebaseDocToMessage(
                            messages[index],
                            FirebaseAuth.instance.currentUser?.uid ??
                                '', // <-- This is the fix
                          );
                          return _MessageBubble(
                            message: message['text'],
                            isMe: message['isMe'],
                            time: message['time'],
                            chatPartnerInitials: widget.chatPartnerInitials,
                            chatPartnerAvatarColor: widget.avatarColor,
                          );
                        },
                      );
                    },
                  )
                : ListView.builder(
                    controller: _scrollController,
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
          SizedBox(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 0.5),
              child: Container(
                padding: const EdgeInsets.only(
                  bottom: 30,
                  top: 20,
                  left: 20,
                  right: 20,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode ? darkSurfaceColor : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? darkBackgroundColor
                              : lightBlueBackground,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: TextField(
                          controller: _messageController,
                          onSubmitted: (_) => _sendMessage(),
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Type a message...',
                            hintStyle: TextStyle(
                              color: isDarkMode ? darkHintColor : Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.mic,
                                color: isDarkMode ? darkPrimaryColor : darkBlue,
                              ),
                              onPressed: () {
                                // Voice message functionality
                              },
                            ),
                          ),
                          style: TextStyle(
                            color: isDarkMode ? darkTextColor : darkBlue,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isDarkMode ? darkPrimaryColor : primaryBlue,
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
          ),
        ],
      ),
    );
  }
}

// _MessageBubble class remains the same but with theme support
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
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    final alignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final backgroundColor = isMe
        ? (isDarkMode ? darkPrimaryColor : myBubbleColor)
        : (isDarkMode ? darkSurfaceColor : partnerBubbleColor);
    final textColor = isMe
        ? Colors.white
        : (isDarkMode ? darkTextColor : darkBlue);
    final timeColor = isDarkMode
        ? darkHintColor.withOpacity(0.6)
        : darkBlue.withOpacity(0.6);

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
                  backgroundColor: chatPartnerAvatarColor!.withOpacity(0.8),
                  child: Text(
                    chatPartnerInitials!,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              if (!isMe) const SizedBox(width: 8),
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
              right: isMe ? 40.0 : 0,
            ),
            child: Text(time, style: TextStyle(color: timeColor, fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
