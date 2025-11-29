import 'package:flutter/material.dart';
import 'admin_lostitems1.dart';
import 'package:tracelink/firebase_service.dart';
import 'package:tracelink/supabase_lost_service.dart';
import 'package:tracelink/supabase_found_service.dart';
import 'package:tracelink/supabase_reports_problems.dart';
import 'package:tracelink/supabase_claims_service.dart';

class AdminWelcome extends StatefulWidget {
  const AdminWelcome({super.key});
  @override
  AdminWelcomeState createState() => AdminWelcomeState();
}

class AdminWelcomeState extends State<AdminWelcome> {
  int activeUsers = 0;
  int totalItems = 0;
  int totalClaims = 0;
  int totalReports = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      // --- 1. FETCH ACTIVE USERS FROM FIREBASE ---
      int users = await FirebaseService().getUserCount();
      // You must implement getUserCount() inside firebase_service.dart

      // --- 2. FETCH LOST ITEMS FROM SUPABASE ---
      int lostCount = await SupabaseLostService().getLostCount();

      // --- 3. FETCH FOUND ITEMS FROM SUPABASE ---
      int foundCount = await SupabaseFoundService().getFoundCount();

      int claimsCount = await SupabaseClaimService().getClaimedCount();

      int reportsCount = await SupabaseReportService().getReports();

      setState(() {
        activeUsers = users;
        totalItems = lostCount + foundCount;
        claimsCount;
        reportsCount;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading dashboard data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : buildDashboard(context),
      ),
    );
  }

  Widget buildDashboard(BuildContext context) {
    return Container(
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
                  // ---------------- TOP ICON SECTION ----------------
                  Container(
                    margin: const EdgeInsets.only(bottom: 32),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
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
                        const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                          size: 80,
                        ),
                      ],
                    ),
                  ),

                  // ---------------- WELCOME TEXT ----------------
                  IntrinsicHeight(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      width: double.infinity,
                      child: Column(
                        children: [
                          IntrinsicWidth(
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 23,
                                    height: 23,
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/0nwacue8_expires_30_days.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 8,
                                      right: 8,
                                    ),
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
                  Container(
                    child: Text(
                      "Administrator",
                      style: TextStyle(color: Color(0xFF002B5B), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(bottom: 26),
                    width: double.infinity,
                    child: const Text(
                      "You're logged in as an administrator. You have full control over the TraceLink system.",
                      style: TextStyle(color: Color(0xFF002B5B), fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),

                  // ------------------- DASHBOARD CARDS -------------------
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 23),
                    child: Column(
                      children: [
                        // ----------------- FIRST ROW (Active Users, Total Items) -----------------
                        Row(
                          children: [
                            Expanded(
                              child: buildStatCard(
                                iconUrl:
                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/40z1tq4e_expires_30_days.png",
                                value: "$activeUsers",
                                label: "Active Users",
                              ),
                            ),
                            const SizedBox(width: 17),
                            Expanded(
                              child: buildStatCard(
                                iconUrl:
                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/t3wut117_expires_30_days.png",
                                value: "$totalItems",
                                label: "Total Items",
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // ------------- Rest of your cards remain unchanged -------------
                        Row(
                          children: [
                            Expanded(
                              child: buildStatCard(
                                iconUrl:
                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/llbpv6t8_expires_30_days.png",
                                value: "$totalClaims",
                                label: "Claims",
                              ),
                            ),
                            const SizedBox(width: 17),
                            Expanded(
                              child: buildStatCard(
                                iconUrl:
                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/n26grs3u_expires_30_days.png",
                                value: "$totalReports",
                                label: "Reports",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ---------- NAVIGATION BUTTON ----------
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
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          begin: Alignment(-1, -1),
                          end: Alignment(-1, 1),
                          colors: [
                            Color(0xFF007BFF),
                            Color(0xFF2196F3),
                            Color(0xFF0056B3),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      margin: const EdgeInsets.only(
                        bottom: 24,
                        left: 23,
                        right: 23,
                      ),
                      child: const Center(
                        child: Text(
                          "Go to Dashboard",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),

                  const Center(
                    child: Text(
                      "Remember to use your admin powers responsibly 👑",
                      style: TextStyle(color: Color(0xFF002B5B), fontSize: 14),
                      textAlign: TextAlign.center,
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

  // -----------------------------------------
  // REUSABLE CARD WIDGET
  // -----------------------------------------
  Widget buildStatCard({
    required String iconUrl,
    required String value,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBDEFB)),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(iconUrl, width: 47, height: 47),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(color: Color(0xFF002B5B), fontSize: 24),
              ),
              Text(
                label,
                style: const TextStyle(color: Color(0xFF002B5B), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
