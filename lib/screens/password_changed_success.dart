import 'package:flutter/material.dart';

//goes back to login screen
import 'login_screen.dart';

class PasswordChangedSuccess extends StatefulWidget {
  const PasswordChangedSuccess({super.key});
  @override
  PasswordChangedSuccessState createState() => PasswordChangedSuccessState();
}

class PasswordChangedSuccessState extends State<PasswordChangedSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          constraints: const BoxConstraints.expand(),

          // --- 2. ADD THIS DECORATION BLOCK ---
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 243, 198, 223), // Very light pink
                Color.fromARGB(
                  255,
                  237,
                  189,
                  235,
                ), // Very light purple/lavender
              ],
            ),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Container(
                    color: Colors.transparent,

                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 233),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only(
                                bottom: 8,
                                left: 23,
                                right: 23,
                              ),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 93),
                                    width: 23,
                                    height: 23,
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/kb63j01i_expires_30_days.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 111,
                                    height: 111,
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/wtuno20g_expires_30_days.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      width: double.infinity,
                                      child: SizedBox(),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 11,
                                    height: 19,
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/loc6qxue_expires_30_days.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 15, left: 31),
                            width: 15,
                            height: 1,
                            child: Image.network(
                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/4d5ezo7g_expires_30_days.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Text(
                                    "Password Reset! 🎉",
                                    style: TextStyle(
                                      color: Color(0xFF980FFA),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 12, left: 41),
                            child: Text(
                              "Your password has been successfully reset!",
                              style: TextStyle(
                                color: Color(0xFF354152),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 47, left: 33),
                            child: Text(
                              "You can now login with your new password ✨",
                              style: TextStyle(
                                color: Color(0xFF980FFA),
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 48),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child: Row(
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    41877300,
                                                  ),
                                              color: Color(0xFFC27AFF),
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            width: 11,
                                            height: 11,
                                            child: SizedBox(),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    41877300,
                                                  ),
                                              color: Color(0xFFFB64B6),
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 9,
                                            ),
                                            width: 11,
                                            height: 11,
                                            child: SizedBox(),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    41877300,
                                                  ),
                                              color: Color(0xFF51A2FF),
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 9,
                                            ),
                                            width: 11,
                                            height: 11,
                                            child: SizedBox(),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                    41877300,
                                                  ),
                                              color: Color(0xFFC27AFF),
                                            ),
                                            width: 11,
                                            height: 11,
                                            child: SizedBox(),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          //****GO BACK TO LOGIN SCREEN */
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            child: IntrinsicHeight(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0x1A000000),
                                      blurRadius: 10,
                                      offset: Offset(0, 8),
                                    ),
                                  ],
                                  gradient: LinearGradient(
                                    begin: Alignment(-1, -1),
                                    end: Alignment(-1, 1),
                                    colors: [
                                      Color.fromARGB(255, 181, 119, 233),
                                      Color.fromARGB(255, 235, 114, 179),
                                      Color.fromARGB(255, 149, 179, 223),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 23,
                                ),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      margin: const EdgeInsets.only(right: 16),
                                      width: 15,
                                      height: 15,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(16),
                                        child: Image.network(
                                          "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/z7p75yo2_expires_30_days.png",
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Back to Login",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 14,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
