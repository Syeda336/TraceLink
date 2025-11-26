import 'package:flutter/material.dart';

import 'login_screen.dart';

class AdminDashboardLogoutConfirmation extends StatefulWidget {
  const AdminDashboardLogoutConfirmation({super.key});
  @override
  AdminDashboardLogoutConfirmationState createState() =>
      AdminDashboardLogoutConfirmationState();
}

class AdminDashboardLogoutConfirmationState
    extends State<AdminDashboardLogoutConfirmation> {
  // Define the new color constants
  static const Color primaryBlue = Color(0xFF007BFF); // Bright Blue
  static const Color darkBlue = Color(0xFF003366); // Dark Blue for text
  static const Color whiteColor = Color(0xFFFFFFFF); // White

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),
          color: whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Container(
                    color: whiteColor,
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              // Semi-transparent blue overlay
                              color: Color(0x80007BFF),
                              padding: const EdgeInsets.symmetric(
                                vertical: 294,
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicHeight(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Color(0x1A000000),
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(16),
                                        color: whiteColor,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x1A000000),
                                            blurRadius: 6,
                                            offset: Offset(0, 4),
                                          ),
                                        ],
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  begin: Alignment(-1, -1),
                                                  end: Alignment(-1, 1),
                                                  colors: [
                                                    primaryBlue, // Bright Blue
                                                    Color(
                                                      0xFF0056B3,
                                                    ), // Darker Blue for gradient effect
                                                  ],
                                                ),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 23,
                                                  ),
                                              margin: const EdgeInsets.only(
                                                top: 2,
                                                bottom: 39,
                                                left: 1,
                                                right: 1,
                                              ),
                                              width: double.infinity,
                                              child: Row(
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                          left: 24,
                                                          right: 12,
                                                        ),
                                                    width: 47,
                                                    height: 47,
                                                    child: Image.network(
                                                      // Assuming this is a white/transparent image suitable for dark background
                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/shidpxsh_expires_30_days.png",
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Logout from Admin Panel",
                                                    style: TextStyle(
                                                      color:
                                                          whiteColor, // White text on blue background
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              bottom: 26,
                                              left: 25,
                                              right: 25,
                                            ),
                                            width: double.infinity,
                                            child: Text(
                                              "Are you sure you want to logout? You will need to login again to access the admin dashboard.",
                                              style: TextStyle(
                                                color:
                                                    darkBlue, // Dark blue text on white background
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 26,
                                                left: 25,
                                                right: 25,
                                              ),
                                              width: double.infinity,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  //** STAY LOGGED IN NAVIGATION GOES TO LOST PAGE* */
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color:
                                                                  darkBlue, // Dark blue border
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  14,
                                                                ),
                                                            color: whiteColor,
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 7,
                                                              ),
                                                          margin:
                                                              const EdgeInsets.only(
                                                                right: 12,
                                                              ),
                                                          width:
                                                              double.infinity,
                                                          child: Column(
                                                            children: [
                                                              Text(
                                                                "Stay Logged In",
                                                                style: TextStyle(
                                                                  color:
                                                                      darkBlue, // Dark blue text
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),

                                                  //***go back to login page navigation */
                                                  Expanded(
                                                    child: InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                const LoginScreen(),
                                                          ),
                                                        );
                                                      },
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  14,
                                                                ),
                                                            gradient: LinearGradient(
                                                              begin: Alignment(
                                                                -1,
                                                                -1,
                                                              ),
                                                              end: Alignment(
                                                                -1,
                                                                1,
                                                              ),
                                                              colors: [
                                                                primaryBlue, // Bright Blue
                                                                Color(
                                                                  0xFF0056B3,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.symmetric(
                                                                vertical: 5,
                                                              ),
                                                          width:
                                                              double.infinity,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            14,
                                                                          ),
                                                                    ),
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      right: 16,
                                                                    ),
                                                                width: 15,
                                                                height: 15,
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        14,
                                                                      ),
                                                                  child: Image.network(
                                                                    // Assuming this is a white/transparent image suitable for dark background
                                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/8k494uz3_expires_30_days.png",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                "Logout",
                                                                style: TextStyle(
                                                                  color:
                                                                      whiteColor, // White text on blue background
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
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
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
