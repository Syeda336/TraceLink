import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracelink/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../notifications_service.dart';

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
  final String? receiverId; // Now critical for fetching real chats

  const ChatScreen({
    super.key,
    required this.chatPartnerName,
    required this.chatPartnerInitials,
    this.isOnline = false,
    required this.avatarColor,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Speech to text variables
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  bool _speechInitialized = false;
  String _lastWords = '';

  // Firebase variables
  Stream<QuerySnapshot>? _messagesStream;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
    _initSpeech();
  }

  void _initSpeech() async {
    try {
      _speechInitialized = await _speech.initialize(
        onStatus: (status) {
          // print('Speech status: $status'); // Debug
          setState(() {
            _isListening = status == 'listening';
          });
        },
        onError: (error) {
          // print('Speech error: $error'); // Debug
          setState(() {
            _isListening = false;
          });
        },
      );
    } catch (e) {
      print('Speech initialization error: $e');
      _speechInitialized = false;
    }
  }

  void _startListening() async {
    if (!_speechInitialized) {
      print('Speech not initialized');
      return;
    }

    _lastWords = '';

    setState(() {
      _isListening = true;
    });

    _speech.listen(
      onResult: (result) {
        setState(() {
          _lastWords = result.recognizedWords;
        });
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: 'en_US',
    );
  }

  void _stopListening() {
    if (!_speechInitialized) return;

    _speech.stop();
    setState(() {
      _isListening = false;
      // When listening stops, populate the text field
      if (_lastWords.isNotEmpty) {
        _messageController.text = _lastWords;
      }
    });
  }

  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  void _initializeChat() async {
    if (widget.receiverId != null && widget.receiverId!.isNotEmpty) {
      try {
        _messagesStream = FirebaseService.getMessages(widget.receiverId!);
        // Mark messages as read when opening chat
        await FirebaseService.markMessagesAsRead(widget.receiverId!);
      } catch (e) {
        print('Error initializing Firebase chat: $e');
      }
    }

    setState(() {
      _isLoading = false;
    });

    // Scroll to bottom after initialization
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _speech.stop();
    super.dispose();
  }

  void _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final messageText = _messageController.text.trim();

    if (widget.receiverId != null) {
      // 1. Send message via Firebase (Existing Logic)
      bool success = await FirebaseService.sendMessage(
        receiverId: widget.receiverId!,
        message: messageText,
        receiverName: widget.chatPartnerName,
        receiverInitials: widget.chatPartnerInitials,
      );

      if (success) {
        _messageController.clear();
        _lastWords = ''; // Clear speech buffer
        _scrollToBottom();

        // 2. TRIGGER NOTIFICATION (NEW CODE)
        try {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            // Construct chatRoomId exactly like the chat service does (sorted IDs)
            List<String> ids = [currentUser.uid, widget.receiverId!];
            ids.sort();
            String chatRoomId = ids.join("_");

            // Use the email username if display name is empty
            String senderName =
                currentUser.displayName ?? currentUser.email!.split('@')[0];

            await NotificationsService.sendMessageNotification(
              targetUserId: widget.receiverId!, // Send to the other person
              senderId: currentUser.uid, // Your ID (so they know who sent it)
              senderName: senderName, // Your Name
              messagePreview: messageText, // The message text
              chatRoomId: chatRoomId, // The specific chat room
            );
          }
        } catch (e) {
          print('Error sending notification: $e');
        }
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to send message")));
      }
    } else {
      // If no receiver ID is present (e.g. error state)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: No user selected to chat with.")),
      );
    }
  }

  // Convert Firebase document to message map
  Map<String, dynamic> _firebaseDocToMessage(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    final data = doc.data() as Map<String, dynamic>;
    final isMe = data['senderId'] == currentUserId;

    // Format timestamp
    String time = '';
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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: isDarkMode ? darkSurfaceColor : primaryBlue,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
                ? const Center(child: CircularProgressIndicator())
                : StreamBuilder<QuerySnapshot>(
                    stream: _messagesStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text(
                            "Say Hello!",
                            style: TextStyle(
                              color: isDarkMode ? darkHintColor : Colors.grey,
                            ),
                          ),
                        );
                      }

                      final messages = snapshot.data!.docs;
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = _firebaseDocToMessage(
                            messages[index],
                            FirebaseAuth.instance.currentUser?.uid ?? '',
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
                  ),
          ),

          // Speech recognition overlay
          if (_isListening)
            Container(
              padding: const EdgeInsets.all(16),
              color: isDarkMode ? darkSurfaceColor : Colors.white,
              child: Column(
                children: [
                  const Icon(Icons.mic, color: Colors.red, size: 30),
                  const SizedBox(height: 8),
                  Text(
                    'Listening...',
                    style: TextStyle(
                      color: isDarkMode ? darkTextColor : darkBlue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _lastWords.isEmpty ? 'Speak now' : _lastWords,
                    style: TextStyle(
                      color: isDarkMode ? darkHintColor : Colors.grey,
                      fontStyle: _lastWords.isEmpty
                          ? FontStyle.italic
                          : FontStyle.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
                                _isListening ? Icons.mic_off : Icons.mic,
                                color: _isListening
                                    ? Colors.red
                                    : (isDarkMode
                                          ? darkPrimaryColor
                                          : darkBlue),
                              ),
                              onPressed: _toggleListening,
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

// _MessageBubble class remains exactly the same
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
