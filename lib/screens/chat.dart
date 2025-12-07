import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracelink/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_service.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../notifications_service.dart';
import 'package:tracelink/supabase_profile_service.dart'; // Import is here

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
  final String?
  receiverId; // Now critical for fetching real chats and pinning/deleting

  const ChatScreen({
    super.key,
    required this.chatPartnerName,
    required this.chatPartnerInitials,
    //this.isOnline = false,
    required this.isOnline,
    required this.avatarColor,
    required this.receiverId,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // 1. **NEW/MODIFIED**: Use a specific name for the partner's image URL
  String? _partnerProfileImageUrl;

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
  bool isPinned = false; // To track state

  @override
  void initState() {
    super.initState();
    _fetchPartnerProfileImage(); // **NEW**: Fetch image on init
    _initializeChat();
    _initSpeech();
    // Check if chat is pinned
    _checkIfPinned();
  }

  // **NEW**: Function to fetch the image URL from Supabase/Firebase
  Future<void> _fetchPartnerProfileImage() async {
    if (widget.receiverId == null) return;
    try {
      // Assuming a function exists in SupabaseProfileService to get the URL
      // This function needs to query the 'Edited_Profile' table for the 'user_image' column.
      final url = await SupabaseProfileService.getProfileImage(
        widget.receiverId!,
      );

      if (mounted) {
        setState(() {
          _partnerProfileImageUrl = url;
        });
      }
    } catch (e) {
      print("Error fetching partner profile image: $e");
    }
  }

  // --- NEW: Helper Function 1 (Check Pin Status) ---
  void _checkIfPinned() {
    if (widget.receiverId == null) return;
    String myId = FirebaseAuth.instance.currentUser!.uid;

    // Listen to my user profile to see if this chat is in 'pinnedChats'
    FirebaseFirestore.instance.collection('users').doc(myId).snapshots().listen(
      (snapshot) {
        if (snapshot.exists && mounted) {
          List<dynamic> pinned = snapshot.data()?['pinnedChats'] ?? [];
          setState(() {
            isPinned = pinned.contains(widget.receiverId);
          });
        }
      },
    );
  }

  // --- HELPER FUNCTIONS START ---

  // 1. Logic for Pinning and Deleting
  // --- NEW: Helper Function 2 (Handle Menu Clicks) ---
  void _handleMenuOption(String value) async {
    if (widget.receiverId == null) return;

    if (value == 'Pin') {
      // 1. Determine the message BEFORE we toggle (fix the logic error)
      String messageText = isPinned ? "Chat Unpinned" : "Chat Pinned";
      // Toggle the pin in Firestore
      await FirebaseService.toggleChatPin(widget.receiverId!);

      // Feedback to user
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(messageText)));
      }
    } else if (value == 'Clear') {
      // Use the new Professional Dialog
      _showProfessionalDialog(
        title: "Delete Chat?",
        content:
            "This will clear the conversation history for you. This action cannot be undone.",
        icon: Icons.delete_forever_rounded,
        iconColor: Colors.red,
        confirmText: "Delete",
        confirmColor: Colors.red,
        onConfirm: () async {
          // Perform the soft delete
          await FirebaseService.clearChat(widget.receiverId!);
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text("Chat cleared")));
          }
        },
      );
    }
  }

  // 2. Logic to View Profile
  void _showProfileDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // **MODIFIED**: Use the fetched image URL in the Profile Dialog
            CircleAvatar(
              radius: 40,
              backgroundColor: widget.avatarColor,
              backgroundImage: _partnerProfileImageUrl != null
                  ? NetworkImage(_partnerProfileImageUrl!)
                  : null,
              child: _partnerProfileImageUrl == null
                  ? Text(
                      widget.chatPartnerInitials,
                      style: const TextStyle(fontSize: 30, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              widget.chatPartnerName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),

            // --- NEW: Fetch 'studentId' from database ---
            FutureBuilder<Map<String, dynamic>?>(
              // Fetch user details using the internal ID
              future: FirebaseService.getUserDataById(widget.receiverId ?? ''),
              builder: (context, snapshot) {
                // 1. Loading State
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                // 2. Get the Student ID
                final data = snapshot.data;
                final studentId = data?['studentId'] ?? '@*d*m!n';

                // 3. Display it
                return Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SelectableText(
                    "ID: $studentId", // <--- Shows the actual Student ID
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.blueGrey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),

            // ---------------------------------------------
            const SizedBox(height: 10),
            Text(
              widget.isOnline ? "Online" : "Offline",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // --- HELPER FUNCTIONS END ---

  //UPDATED UI
  // --- PROFESSIONAL DIALOG DEFINITION ---
  void _showProfessionalDialog({
    required String title,
    required String content,
    required IconData icon,
    required Color iconColor,
    required String confirmText,
    required Color confirmColor,
    required VoidCallback onConfirm,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final contentColor = isDark ? Colors.grey[300] : Colors.grey[700];

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        // 1. CRITICAL: Remove default white rect and shadow
        backgroundColor: Colors.transparent,
        elevation: 0,
        insetPadding: const EdgeInsets.all(20), // Make it responsive

        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(24), // Highly rounded corners
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10), // Deep drop shadow
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content tightly
            children: [
              // --- ICON BUBBLE ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 36, color: iconColor),
              ),
              const SizedBox(height: 24),

              // --- TITLE ---
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontFamily: 'Roboto', // Or your app font
                ),
              ),
              const SizedBox(height: 12),

              // --- CONTENT ---
              Text(
                content,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: contentColor,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // --- BUTTONS ---
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: contentColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Confirm Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                        onConfirm();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: confirmColor,
                        foregroundColor: Colors.white,
                        elevation: 0, // Flat modern look
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
        isInitialMessage: false, // <--- ADD THIS LINE to prevent name swapping
      );

      if (success) {
        _messageController.clear();
        _lastWords = ''; // Clear speech buffer
        _scrollToBottom();

        // 2. TRIGGER NOTIFICATION (FIXED)
        try {
          final currentUser = FirebaseAuth.instance.currentUser;
          if (currentUser != null) {
            List<String> ids = [currentUser.uid, widget.receiverId!];
            ids.sort();
            String chatRoomId = ids.join("_");

            // --- NEW: Fetch YOUR real name from Firestore ---
            // This ensures we send "John Doe" instead of "User 2"
            String senderName = 'Someone';
            try {
              DocumentSnapshot userDoc = await FirebaseFirestore.instance
                  .collection('users')
                  .doc(currentUser.uid)
                  .get();

              if (userDoc.exists) {
                senderName = userDoc['fullName'] ?? senderName;
              }
            } catch (e) {
              print("Could not fetch name for notification: $e");
            }
            // -----------------------------------------------

            await NotificationsService.sendMessageNotification(
              targetUserId: widget.receiverId!,
              senderId: currentUser.uid,
              senderName: senderName, // <--- Now contains the correct name
              messagePreview: messageText,
              chatRoomId: chatRoomId,
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

  // **NEW**: Function to build the CircleAvatar for the chat partner
  Widget _buildPartnerAvatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: widget.avatarColor.withOpacity(0.8),
      backgroundImage: _partnerProfileImageUrl != null
          ? NetworkImage(_partnerProfileImageUrl!)
          : null,
      child: _partnerProfileImageUrl == null
          ? Text(
              widget.chatPartnerInitials,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            )
          : null,
    );
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
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0, // Reduces gap between arrow and avatar
        // --- NEW: Wrapped in InkWell to make it CLICKABLE ---
        title: InkWell(
          onTap: _showProfileDialog, // <--- Calls the profile function
          child: Row(
            children: [
              // **MODIFIED**: Use the new avatar builder function
              _buildPartnerAvatar(),
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
        ),

        // --- NEW: Replaced IconButton with PopupMenuButton ---
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: PopupMenuButton<String>(
              // 1. Round the menu corners and add shadow
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              offset: const Offset(0, 50), // Move it slightly down
              icon: const Icon(Icons.more_vert, color: Colors.white),

              onSelected: _handleMenuOption,
              itemBuilder: (BuildContext context) {
                return [
                  // --- PIN OPTION ---
                  PopupMenuItem(
                    value: 'Pin',
                    child: Row(
                      children: [
                        // Dynamic Icon (Pinned vs Unpinned)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          isPinned ? "Unpin Chat" : "Pin Chat",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- DIVIDER ---
                  const PopupMenuDivider(height: 1),

                  // --- DELETE OPTION ---
                  PopupMenuItem(
                    value: 'Clear',
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.delete_forever_rounded,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Delete Chat",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ];
              },
            ),
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

                      // 1. FILTERING HAPPENS HERE
                      // Get all docs, but throw away the ones marked as deleted for me
                      final currentUserId =
                          FirebaseAuth.instance.currentUser?.uid;

                      final messages = snapshot.data!.docs.where((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        final deletedIds = List<String>.from(
                          data['deletedIds'] ?? [],
                        );
                        // Keep message ONLY if my ID is NOT in the deleted list
                        return !deletedIds.contains(currentUserId);
                      }).toList();

                      // 2. CHECK IF EMPTY AFTER FILTERING
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            "No messages",
                            style: TextStyle(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? const Color(0xFFB0B0B0)
                                  : Colors.grey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16.0),
                        itemCount: messages.length, // Now this count is correct
                        itemBuilder: (context, index) {
                          final message = _firebaseDocToMessage(
                            messages[index], // Use the filtered list
                            currentUserId ?? '',
                          );

                          return _MessageBubble(
                            message: message['text'],
                            isMe: message['isMe'],
                            time: message['time'],
                            chatPartnerInitials: widget.chatPartnerInitials,
                            chatPartnerAvatarColor: widget.avatarColor,
                            // **NEW**: Pass the image URL to the bubble
                            chatPartnerImageUrl: _partnerProfileImageUrl,
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
  final String? chatPartnerImageUrl; // **NEW**: Image URL

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.time,
    this.chatPartnerInitials,
    this.chatPartnerAvatarColor,
    this.chatPartnerImageUrl, // **NEW**: Include in constructor
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
                // **MODIFIED**: Use the image URL if available
                CircleAvatar(
                  radius: 16,
                  backgroundColor: chatPartnerAvatarColor!.withOpacity(0.8),
                  backgroundImage: chatPartnerImageUrl != null
                      ? NetworkImage(chatPartnerImageUrl!)
                      : null,
                  child: chatPartnerImageUrl == null
                      ? Text(
                          chatPartnerInitials!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        )
                      : null, // No text if image is present
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
