import 'package:flutter/material.dart';
import 'warning_admin.dart'; // Target screen to open after action

class ContactAdminDialog extends StatelessWidget {
  const ContactAdminDialog({super.key});

  // Function to close the dialog and navigate to the warning_admin.dart screen
  void _handleAction(BuildContext context) {
    // 1. Close the current dialog
    Navigator.pop(context);

    // 2. Navigate to the WarningAdminScreen (using pushReplacement to clear the stack if needed)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const WarningScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      elevation: 10.0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // --- Header and Close Button ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.blueAccent),
                    SizedBox(width: 8),
                    Text(
                      'Contact Admin',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => _handleAction(context), // Close action
                  child: const Icon(Icons.close, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Send a message to the admin regarding this warning',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),

            // --- Item Info Box ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3E5F5), // Light purple background
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Item: Set of Keys',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF9C27B0), // Purple color
                ),
              ),
            ),
            const SizedBox(height: 15),

            // --- Text Input Field ---
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: const TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText:
                      'Type your message here... Explain your situation or ask any questions.',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 25),

            // --- Action Buttons ---
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Cancel Button
                SizedBox(
                  width: 100,
                  height: 45,
                  child: OutlinedButton.icon(
                    onPressed: () => _handleAction(context), // Close action
                    icon: const Icon(
                      Icons.close,
                      size: 20,
                      color: Colors.black54,
                    ),
                    label: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.black54),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Send Button (with Gradient)
                Container(
                  width: 100,
                  height: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF2196F3),
                        Color(0xFF4CAF50),
                      ], // Blue to Green gradient for Send
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _handleAction(context), // Send/Close action
                    icon: const Icon(Icons.send, size: 20, color: Colors.white),
                    label: const Text(
                      'Send',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.transparent, // Important for gradient
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
