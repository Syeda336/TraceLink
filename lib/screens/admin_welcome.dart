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
          color: Color(0xFFFFFFFF),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: IntrinsicHeight(
                  child: Container(
                    color: Color(0xFFFFFFFF),
                    width: double.infinity,
                    height: double.infinity,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(vertical: 56),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 32),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child:
                                          //CHANGE HERE
                                          Stack(
                                            alignment: Alignment
                                                .center, // This centers the crown on the circle
                                            children: [
                                              // The CIRCLE (now first, so it's in the back)
                                              Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        127,
                                                      ), // Cleaner border radius
                                                  gradient: LinearGradient(
                                                    begin: Alignment(-1, -1),
                                                    end: Alignment(-1, 1),
                                                    colors: [
                                                      Color(0xFFFDC700),
                                                      Color(0xFFFF8803),
                                                    ],
                                                  ),
                                                ),
                                                width: 127,
                                                height: 127,
                                                child: SizedBox(),
                                              ),
                                              // The CROWN (now second, so it's on top)
                                              Align(
                                                alignment: Alignment(0.0, 1.0),

                                                child: SizedBox(
                                                  width: 127,
                                                  height: 127,
                                                  child: Image.network(
                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/72lhip8g_expires_30_days.png",
                                                    // Removed fit: BoxFit.fill, it might look better without it
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
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            width: 23,
                                            height: 23,
                                            child: Image.network(
                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/0nwacue8_expires_30_days.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 9,
                                            ),
                                            child: Text(
                                              "Welcome Back!",
                                              style: TextStyle(
                                                color: Color(0xFFD08700),
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
                              child: Column(
                                children: [
                                  Text(
                                    "Administrator",
                                    style: TextStyle(
                                      color: Color(0xFF1D2838),
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 26, left: 33),
                            width: 286,
                            child: Text(
                              "You're logged in as an administrator. You have full control over the Lost & Found system.",
                              style: TextStyle(
                                color: Color(0xFF495565),
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
                                                    color: Color(0xFFFEF9C1),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Color(0xFFFFFFFF),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x1A000000),
                                                      blurRadius: 6,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                      margin:
                                                          const EdgeInsets.only(
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
                                                              child: Text(
                                                                "1,234",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF101727,
                                                                  ),
                                                                  fontSize: 24,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "Active Users",
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF697282,
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
                                                    color: Color(0xFFFEF9C1),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Color(0xFFFFFFFF),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Color(0x1A000000),
                                                      blurRadius: 6,
                                                      offset: Offset(0, 4),
                                                    ),
                                                  ],
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 16,
                                                    ),
                                                width: double.infinity,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
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
                                                              child: Text(
                                                                "847",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF101727,
                                                                  ),
                                                                  fontSize: 24,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "Total Items",
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF697282,
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
                                                    color: Color(0xFFFEF9C1),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Color(0xFFFFFFFF),
                                                  boxShadow: [
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
                                                      margin:
                                                          const EdgeInsets.only(
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
                                                              child: Text(
                                                                "92%",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF101727,
                                                                  ),
                                                                  fontSize: 24,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              "Return Rate",
                                                              style: TextStyle(
                                                                color: Color(
                                                                  0xFF697282,
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
                                                    color: Color(0xFFFEF9C1),
                                                    width: 1,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(16),
                                                  color: Color(0xFFFFFFFF),
                                                  boxShadow: [
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
                                                      margin:
                                                          const EdgeInsets.only(
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
                                                          width:
                                                              double.infinity,
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
                                                                child: Text(
                                                                  "15",
                                                                  style: TextStyle(
                                                                    color: Color(
                                                                      0xFF101727,
                                                                    ),
                                                                    fontSize:
                                                                        24,
                                                                  ),
                                                                ),
                                                              ),
                                                              IntrinsicHeight(
                                                                child: Container(
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        bottom:
                                                                            1,
                                                                      ),
                                                                  width: double
                                                                      .infinity,
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        "Pending Alerts",
                                                                        style: TextStyle(
                                                                          color: Color(
                                                                            0xFF697282,
                                                                          ),
                                                                          fontSize:
                                                                              12,
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
                              margin: const EdgeInsets.only(bottom: 33),
                              width: double.infinity,
                              child: Column(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print('Pressed');
                                    },
                                    child: IntrinsicWidth(
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x1A000000),
                                                blurRadius: 6,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                            gradient: LinearGradient(
                                              begin: Alignment(-1, -1),
                                              end: Alignment(-1, 1),
                                              colors: [
                                                Color(0xFFFDC700),
                                                Color(0xFFFF8803),
                                                Color(0xFFFF6366),
                                              ],
                                            ),
                                          ),
                                          padding: const EdgeInsets.only(
                                            top: 11,
                                            bottom: 11,
                                            left: 24,
                                            right: 24,
                                          ),
                                          child: Row(
                                            children: [
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  right: 8,
                                                ),
                                                width: 19,
                                                height: 19,
                                                child: Image.network(
                                                  "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/lrv9rlhl_expires_30_days.png",
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                              Text(
                                                "Administrator Privileges Active",
                                                style: TextStyle(
                                                  color: Color(0xFFFFFFFF),
                                                  fontSize: 16,
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

                          /*****ADDING NAVIGATION To lost admin screen******* */
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
                                      Color(0xFFF0B000),
                                      Color(0xFFFF6800),
                                      Color(0xFFFA2B36),
                                    ],
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 13,
                                ),
                                margin: const EdgeInsets.only(
                                  bottom: 24,
                                  left: 23,
                                  right: 23,
                                ),
                                width: double.infinity,
                                child: Column(
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

                          Align(
                            alignment: Alignment(
                              0.5,
                              0.0,
                            ), // <-- Now this aligns relative to the screen
                            child: Text(
                              "Remember to use your admin powers responsibly 👑",
                              style: TextStyle(
                                color: Color(0xFF697282),
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
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
