import 'package:flutter/material.dart';
import 'admin_lostitems1.dart';

class AdminWelcome extends StatefulWidget {
  const AdminWelcome({super.key});
  @override
  AdminWelcomeState createState() => AdminWelcomeState();
}

class AdminWelcomeState extends State<AdminWelcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: const Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 56),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- TOP ICON SECTION ---
                      Container(
                        margin: const EdgeInsets.only(bottom: 32),
                        width: double.infinity,
                        alignment:
                            Alignment.center, // Center the icon container
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Circle
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(127),
                                gradient: const LinearGradient(
                                  begin: Alignment(-1, -1),
                                  end: Alignment(-1, 1),
                                  colors: [
                                    Color(0xFF007BFF),
                                    Color(0xFF2196F3),
                                    Color(0xFF0056B3),
                                  ],
                                ),
                              ),
                              width: 127,
                              height: 127,
                            ),
                            // **UPDATED: Replaced Network Image with standard Icon**
                            const Icon(
                              Icons.admin_panel_settings,
                              color: Colors.white,
                              size: 80, // Adjust size as needed
                            ),
                          ],
                        ),
                      ),

                      // --- END TOP ICON SECTION ---
                      IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          width: double.infinity,
                          child: Column(
                            children: [
                              IntrinsicWidth(
                                child: IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(right: 8),
                                        width: 23,
                                        height: 23,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/0nwacue8_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      Container(
                                        margin: const EdgeInsets.only(right: 9),
                                        child: const Text(
                                          "Welcome Back!",
                                          style: TextStyle(
                                            color: Color(0xFF007BFF),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 23,
                                        height: 23,
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/encnyyd9_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 17),
                          width: double.infinity,
                          child: const Column(
                            children: [
                              Text(
                                "Administrator",
                                style: TextStyle(
                                  color: Color(0xFF002B5B),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: 26,
                          // left: 540, // Removed extraneous margin
                        ),
                        width: double.infinity, // Use full width to center text
                        child: const Text(
                          "You're logged in as an administrator. You have full control over the TraceLink system.",
                          style: TextStyle(
                            color: Color(0xFF002B5B),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IntrinsicHeight(
                        child: Container(
                          margin: const EdgeInsets.only(
                            bottom: 33,
                            left: 23,
                            right: 23,
                          ),
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IntrinsicHeight(
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: IntrinsicHeight(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFBBDEFB),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: const Color(0xFFFFFFFF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x1A000000),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 17,
                                            ),
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 12,
                                                  ),
                                                  width: 47,
                                                  height: 47,
                                                  child: Image.network(
                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/40z1tq4e_expires_30_days.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                IntrinsicWidth(
                                                  child: IntrinsicHeight(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                bottom: 1,
                                                              ),
                                                          child: const Text(
                                                            "1,234",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF002B5B,
                                                              ),
                                                              fontSize: 24,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text(
                                                          "Active Users",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF002B5B,
                                                            ),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: IntrinsicHeight(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFBBDEFB),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: const Color(0xFFFFFFFF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x1A000000),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                            ),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    left: 17,
                                                    right: 12,
                                                  ),
                                                  width: 47,
                                                  height: 47,
                                                  child: Image.network(
                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/t3wut117_expires_30_days.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                IntrinsicWidth(
                                                  child: IntrinsicHeight(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                bottom: 1,
                                                                right: 19,
                                                              ),
                                                          child: const Text(
                                                            "847",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF002B5B,
                                                              ),
                                                              fontSize: 24,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text(
                                                          "Total Items",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF002B5B,
                                                            ),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              IntrinsicHeight(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: IntrinsicHeight(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFBBDEFB),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: const Color(0xFFFFFFFF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x1A000000),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.only(
                                              top: 17,
                                              bottom: 33,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 17,
                                            ),
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 12,
                                                  ),
                                                  width: 47,
                                                  height: 47,
                                                  child: Image.network(
                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/llbpv6t8_expires_30_days.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                IntrinsicWidth(
                                                  child: IntrinsicHeight(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                bottom: 1,
                                                                right: 15,
                                                              ),
                                                          child: const Text(
                                                            "92%",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF002B5B,
                                                              ),
                                                              fontSize: 24,
                                                            ),
                                                          ),
                                                        ),
                                                        const Text(
                                                          "Return Rate",
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF002B5B,
                                                            ),
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: IntrinsicHeight(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: const Color(0xFFBBDEFB),
                                                width: 1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              color: const Color(0xFFFFFFFF),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Color(0x1A000000),
                                                  blurRadius: 6,
                                                  offset: Offset(0, 4),
                                                ),
                                              ],
                                            ),
                                            padding: const EdgeInsets.only(
                                              left: 17,
                                              right: 17,
                                            ),
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                    top: 25,
                                                    bottom: 25,
                                                    right: 12,
                                                  ),
                                                  width: 45,
                                                  height: 47,
                                                  child: Image.network(
                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/n26grs3u_expires_30_days.png",
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: IntrinsicHeight(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            top: 17,
                                                          ),
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            margin:
                                                                const EdgeInsets.only(
                                                                  bottom: 1,
                                                                ),
                                                            child: const Text(
                                                              "15",
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF002B5B,
                                                                ),
                                                                fontSize: 24,
                                                              ),
                                                            ),
                                                          ),
                                                          // **UPDATED: Simplified layout to fix text alignment**
                                                          const Text(
                                                            "Pending Alerts",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF002B5B,
                                                              ),
                                                              fontSize: 12,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Navigation to Lost Items Dashboard
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AdminDashboard1LostItems(),
                            ),
                          );
                        },
                        child: IntrinsicHeight(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x1A000000),
                                  blurRadius: 10,
                                  offset: Offset(0, 8),
                                ),
                              ],
                              gradient: const LinearGradient(
                                begin: Alignment(-1, -1),
                                end: Alignment(-1, 1),
                                colors: [
                                  Color(0xFF007BFF),
                                  Color(0xFF2196F3),
                                  Color(0xFF0056B3),
                                ],
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            margin: const EdgeInsets.only(
                              bottom: 24,
                              left: 23,
                              right: 23,
                            ),
                            width: double.infinity,
                            child: const Column(
                              children: [
                                Text(
                                  "Go to Dashboard",
                                  style: TextStyle(
                                    color: Color(0xFFFFFFFF),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // **UPDATED: Centered the last text**
                      const Center(
                        child: Text(
                          "Remember to use your admin powers responsibly 👑",
                          style: TextStyle(
                            color: Color(0xFF002B5B),
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
