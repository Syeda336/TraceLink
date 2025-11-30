import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'settings.dart';
import '../theme_provider.dart';

// --- Color Palette ---
const Color _kPrimaryBrightBlue = Colors.blue;
const Color _kSecondaryBrightBlue = Color(0xFF42A5F5);
const Color _kDarkBlueText = Color(0xFF0D47A1);

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  // --- Data & Keys ---
  final Map<String, GlobalKey> _itemKeys = {};

  final List<Map<String, dynamic>> _allGuides = [
    {
      "title": "Getting Started",
      "subtitle": "How to post items and search.",
      "icon": Icons.rocket_launch_outlined,
      "color": Colors.orange,
      "content":
          "To get started:\n\n1. Go to the home screen.\n2. Select whether you lost or found an item.\n3. Upload a photo or use AI image generator and add a description.\n4. Hit publish!"
    },
    {
      "title": "Safety Guidelines",
      "subtitle": "Meeting safely and verifying.",
      "icon": Icons.security_outlined,
      "color": Colors.green,
      "content":
          "Safety First:\n\n1. Always meet in public places.\n2. Bring a friend along if possible.\n3. Verify the item details before meeting.\n4. Do not share personal financial info."
    },
  ];

  final List<Map<String, dynamic>> _allFAQs = [
    {
      "question": "How do I report a lost item?",
      "answer":
          "Tap the Report Lost button  on the home screen.Upload a photo and fill in the details."
    },
    {
      "question": "Is my personal info visible?",
      "answer":
          "Other users can only see your Student ID by default. You have the option to make your phone number or email visible in your profile settings, but this is completely optional."
    },
    {
      "question": "How do I claim a found item?",
      "answer":
          "Tap on the item and select 'Claim Item'. You may need to answer a security question."
    },
    {
      "question": "What if I forgot my current password?",
      "answer":
          "If you've forgotten your password, you can easily reset it using the Forgot Password feature on the login screen.\nJust tap on it, enter the email address associated with your account, and we will send you a secure link to create a new password.\nSimply follow the instructions in that email to regain access to your account."
    },
  ];

  final TextEditingController _searchController = TextEditingController();

  // --- Support Form Controllers ---
  String? _selectedIssue;
  final TextEditingController _messageController = TextEditingController();
  final List<String> _issueTypes = [
    'Account Issue',
    'Bug Report',
    'Feature Request',
    'Safety Concern',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    for (var guide in _allGuides) {
      _itemKeys[guide['title']] = GlobalKey();
    }
    for (var faq in _allFAQs) {
      _itemKeys[faq['question']] = GlobalKey();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  // --- Scroll Logic ---
  void _scrollToMatch(String query) {
    if (query.isEmpty) return;

    final lowerQuery = query.toLowerCase();
    BuildContext? targetContext;

    for (var guide in _allGuides) {
      if (guide['title'].toLowerCase().contains(lowerQuery)) {
        targetContext = _itemKeys[guide['title']]?.currentContext;
        break;
      }
    }

    if (targetContext == null) {
      for (var faq in _allFAQs) {
        if (faq['question'].toLowerCase().contains(lowerQuery)) {
          targetContext = _itemKeys[faq['question']]?.currentContext;
          break;
        }
      }
    }

    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
        alignment: 0.2,
      );
    }
  }

  // --- Action: Open Support Form ---
  void _openSupportForm(bool isDarkMode) {
    _selectedIssue = null;
    _messageController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Contact Support",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : _kDarkBlueText,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Select a topic so we can help you faster.",
                    style: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  DropdownButtonFormField<String>(
                    value: _selectedIssue,
                    dropdownColor: isDarkMode ? Colors.grey[800] : Colors.white,
                    decoration: InputDecoration(
                      labelText: "What can we help with?",
                      labelStyle: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
                      ),
                    ),
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black),
                    items: _issueTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        _selectedIssue = newValue;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 15),

                  TextField(
                    controller: _messageController,
                    maxLines: 4,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    decoration: InputDecoration(
                      labelText: "Describe your issue...",
                      labelStyle: TextStyle(
                          color: isDarkMode ? Colors.grey[400] : Colors.grey[600]),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                            color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_selectedIssue == null) {
                          _showStatusMessage("Please select a topic.");
                          return;
                        }
                        _launchEmailWithDetails();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kPrimaryBrightBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text("Draft Email", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- UPDATED EMAIL LAUNCHER ---
  Future<void> _launchEmailWithDetails() async {
    
    const String destinationEmail = 'atracelink@gmail.com'; 
    
    final String subject = 'Support Request: $_selectedIssue';
    final String body = 'Issue Type: $_selectedIssue\n\nDescription:\n${_messageController.text}';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: destinationEmail,
      queryParameters: {
        'subject': subject,
        'body': body,
      },
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        // Fallback for Emulator or if no email app is installed
        if (mounted) {
           showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.grey[900] 
                  : Colors.white,
              title: Text(
                "Contact Support",
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : Colors.black
                )
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "We couldn't open your email app automatically. Please email us at: atracelink@gmail.com",
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[300] 
                          : Colors.grey[800]
                    ),
                  ),
                  const SizedBox(height: 10),
                  SelectableText(
                    destinationEmail,
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      fontSize: 16,
                      color: _kPrimaryBrightBlue
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Topic: $_selectedIssue",
                     style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark 
                          ? Colors.grey[400] 
                          : Colors.grey[700]
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("OK"),
                )
              ],
            ),
          );
        }
      }
    } catch (e) {
      _showStatusMessage("Error launching email.");
    }
  }

  void _showGuideContent(
      BuildContext context, String title, String content, bool isDarkMode) {
    showModalBottomSheet(
      context: context,
      backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              Text(title,
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : _kDarkBlueText)),
              const SizedBox(height: 15),
              Text(content,
                  style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[800])),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: _kPrimaryBrightBlue,
                      foregroundColor: Colors.white),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showStatusMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildSearchBar(bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _scrollToMatch(value),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        decoration: InputDecoration(
          hintText: "Find in page (e.g. 'Safety')...",
          hintStyle: TextStyle(
            color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
          ),
          prefixIcon: Icon(
            Icons.search,
            color: isDarkMode ? Colors.grey[400] : Colors.grey[500],
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[500]),
            onPressed: () {
              _searchController.clear();
              FocusScope.of(context).unfocus();
            },
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bool isDarkMode = themeProvider.isDarkMode;
    final Color scaffoldBgColor =
        isDarkMode ? Colors.grey[900]! : const Color(0xFFF8F9FD);

    return Scaffold(
      backgroundColor: scaffoldBgColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160.0,
            pinned: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              // --- CHANGED HERE: Replaced pushReplacement with pop ---
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [_kPrimaryBrightBlue, _kSecondaryBrightBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.only(left: 20, bottom: 30, right: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Help Center',
                        style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 5),
                      Text(
                        "How can we help you today?",
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSearchBar(isDarkMode),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    "User Guide",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : _kDarkBlueText,
                    ),
                  ),
                ),

                ..._allGuides.map((guide) => Container(
                      key: _itemKeys[guide['title']],
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDarkMode
                                ? Colors.grey[700]!
                                : Colors.grey[200]!),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: guide['color'].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(guide['icon'], color: guide['color']),
                        ),
                        title: Text(
                          guide['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : _kDarkBlueText,
                          ),
                        ),
                        subtitle: Text(
                          guide['subtitle'],
                          style: TextStyle(
                            color: isDarkMode
                                ? Colors.grey[400]
                                : Colors.grey[600],
                            fontSize: 13,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios,
                            size: 14, color: Colors.grey[400]),
                        onTap: () => _showGuideContent(
                          context,
                          guide['title'],
                          guide['content'],
                          isDarkMode,
                        ),
                      ),
                    )),

                const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Text(
                    "Frequently Asked Questions",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : _kDarkBlueText,
                    ),
                  ),
                ),

                ..._allFAQs.map((faq) => Container(
                      key: _itemKeys[faq['question']],
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey[800] : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDarkMode
                                ? Colors.grey[700]!
                                : Colors.grey[200]!),
                      ),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          title: Text(
                            faq['question'],
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color:
                                  isDarkMode ? Colors.white : Colors.grey[800],
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              child: Text(
                                faq['answer'],
                                style: TextStyle(
                                  height: 1.5,
                                  color: isDarkMode
                                      ? Colors.grey[300]
                                      : Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kPrimaryBrightBlue, _kSecondaryBrightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.support_agent,
                          color: Colors.white, size: 40),
                      const SizedBox(height: 15),
                      const Text(
                        "Still need help?",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Send us an email and we'll get back to you.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.9), fontSize: 14),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () => _openSupportForm(isDarkMode),
                        icon: const Icon(Icons.email_outlined),
                        label: const Text("Contact Support"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _kPrimaryBrightBlue,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}