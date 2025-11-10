import 'package:flutter/material.dart';

//can go to lost , found , claims

import 'admin_lostitems1.dart';
import 'admin_founditems.dart';
import 'admin_claims.dart';

class AdminDashboardAfterWarningUser extends StatefulWidget {
  const AdminDashboardAfterWarningUser({super.key});
  @override
  AdminDashboardAfterWarningUserState createState() =>
      AdminDashboardAfterWarningUserState();
}

class AdminDashboardAfterWarningUserState
    extends State<AdminDashboardAfterWarningUser> {
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(24),
                                  bottomLeft: Radius.circular(24),
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
                                    Color(0xFFAC46FF),
                                    Color(0xFFF6329A),
                                  ],
                                ),
                              ),
                              margin: const EdgeInsets.only(bottom: 24),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicHeight(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        top: 47,
                                        bottom: 16,
                                        left: 23,
                                        right: 23,
                                      ),
                                      width: double.infinity,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          IntrinsicWidth(
                                            child: IntrinsicHeight(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Admin Dashboard 🛡️",
                                                    style: TextStyle(
                                                      color: Color(0xFFFFFFFF),
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 87,
                                            height: 39,
                                            child: Image.network(
                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/so4j37l1_expires_30_days.png",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IntrinsicHeight(
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 24,
                                        left: 23,
                                        right: 35,
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        children: [
                                          Text(
                                            "Manage all reports and handle user misconduct",
                                            style: TextStyle(
                                              color: Color(0xFFFFFEFE),
                                              fontSize: 16,
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
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x4D000000),
                                    blurRadius: 2,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 4,
                                right: 4,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 25,
                                left: 23,
                                right: 48,
                              ),
                              width: double.infinity,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //****GO BACK TO LOST ITEMS PAGE */
                                  Expanded(
                                    child: InkWell(
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
                                            border: Border.all(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Color(0xFFFFFFFF),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 1,
                                          ),
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Lost",
                                                style: TextStyle(
                                                  color: Color(0xFF0A0A0A),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //****GO BACK TO FOUND ITEMS PAGE */
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminDashboard2FoundItems(),
                                          ),
                                        );
                                      },
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          margin: const EdgeInsets.only(
                                            right: 1,
                                          ),
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Found",
                                                style: TextStyle(
                                                  color: Color(0xFF0A0A0A),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  //*****GO TO CLAIMS PAGE  */
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const AdminDashboardClaimScreen1(),
                                          ),
                                        );
                                      },
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0x00000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Claims",
                                                style: TextStyle(
                                                  color: Color(0xFF0A0A0A),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        print('Pressed');
                                      },
                                      child: IntrinsicHeight(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Color(0x47000000),
                                              width: 1,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Color(0xFFFFFFFF),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Color(0x40000000),
                                                blurRadius: 4,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          width: double.infinity,
                                          child: Column(
                                            children: [
                                              Text(
                                                "Reports",
                                                style: TextStyle(
                                                  color: Color(0xFF0A0A0A),
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
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x1A000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                                gradient: LinearGradient(
                                  begin: Alignment(-1, -1),
                                  end: Alignment(-1, 1),
                                  colors: [
                                    Color(0xFFFF1F56),
                                    Color(0xFFFF8803),
                                  ],
                                ),
                              ),
                              padding: const EdgeInsets.only(
                                top: 15,
                                bottom: 15,
                                left: 16,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 17,
                                left: 23,
                                right: 48,
                              ),
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(right: 12),
                                    width: 39,
                                    height: 39,
                                    child: Image.network(
                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/dxpggjwx_expires_30_days.png",
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  IntrinsicWidth(
                                    child: IntrinsicHeight(
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                          bottom: 1,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "User Misconduct Reports",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFFFFFFFF,
                                                        ),
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            IntrinsicWidth(
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                    right: 68,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "0 pending reports",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFFFFFEFE,
                                                          ),
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
                                ],
                              ),
                            ),
                          ),
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x4D000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 14,
                                left: 23,
                                right: 48,
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicHeight(
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 16),
                                      margin: const EdgeInsets.only(
                                        top: 16,
                                        bottom: 21,
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IntrinsicWidth(
                                                    child: IntrinsicHeight(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Set of Keys",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF101727,
                                                              ),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      print('Pressed');
                                                    },
                                                    child: IntrinsicWidth(
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Color(
                                                                0x00000000,
                                                              ),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            color: Color(
                                                              0xFFF3F4F6,
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 2,
                                                                bottom: 2,
                                                                left: 7,
                                                                right: 7,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Resolved",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF354152,
                                                                  ),
                                                                  fontSize: 12,
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
                                          IntrinsicWidth(
                                            child: IntrinsicHeight(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    IntrinsicWidth(
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                right: 21,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Reported User:",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFFEC003F,
                                                                  ),
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "emma_wilson",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF495565,
                                                        ),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          IntrinsicWidth(
                                            child: IntrinsicHeight(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 4,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    IntrinsicWidth(
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                right: 18,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Reported By:",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF354152,
                                                                  ),
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "abdullah89",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF495565,
                                                        ),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          IntrinsicWidth(
                                            child: IntrinsicHeight(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Oct 14, 2025",
                                                    style: TextStyle(
                                                      color: Color(0xFF697282),
                                                      fontSize: 14,
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
                                  InkWell(
                                    onTap: () {
                                      print('Pressed');
                                    },
                                    child: IntrinsicHeight(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Color(0xFFFFF1F2),
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 12,
                                          bottom: 12,
                                          left: 13,
                                          right: 13,
                                        ),
                                        margin: const EdgeInsets.only(
                                          bottom: 28,
                                        ),
                                        width: double.infinity,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                right: 13,
                                              ),
                                              width: 15,
                                              height: 15,
                                              child: Image.network(
                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/a51ums1t_expires_30_days.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  "Finder is not responding to messages and refusing to return the item",
                                                  style: TextStyle(
                                                    color: Color(0xFF354152),
                                                    fontSize: 14,
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
                          IntrinsicHeight(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Color(0xFFFFFFFF),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0x4D000000),
                                    blurRadius: 4,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.only(
                                left: 15,
                                right: 15,
                              ),
                              margin: const EdgeInsets.only(
                                bottom: 103,
                                left: 24,
                                right: 47,
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicHeight(
                                    child: Container(
                                      padding: const EdgeInsets.only(right: 14),
                                      margin: const EdgeInsets.only(
                                        top: 15,
                                        bottom: 21,
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 8,
                                              ),
                                              width: double.infinity,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IntrinsicWidth(
                                                    child: IntrinsicHeight(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Leather Wallet",
                                                            style: TextStyle(
                                                              color: Color(
                                                                0xFF101727,
                                                              ),
                                                              fontSize: 16,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      print('Pressed');
                                                    },
                                                    child: IntrinsicWidth(
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Color(
                                                                0x00000000,
                                                              ),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            color: Color(
                                                              0xFFF3F4F6,
                                                            ),
                                                          ),
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 2,
                                                                bottom: 2,
                                                                left: 8,
                                                                right: 8,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Resolved",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF354152,
                                                                  ),
                                                                  fontSize: 12,
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
                                          IntrinsicWidth(
                                            child: IntrinsicHeight(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 3,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    IntrinsicWidth(
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                right: 14,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Reported User:",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFFEC003F,
                                                                  ),
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "lisa_davis",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF495565,
                                                        ),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          IntrinsicWidth(
                                            child: IntrinsicHeight(
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 5,
                                                  left: 1,
                                                ),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    IntrinsicWidth(
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets.only(
                                                                right: 33,
                                                              ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Reported By:",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF354152,
                                                                  ),
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Text(
                                                      "faseeha",
                                                      style: TextStyle(
                                                        color: Color(
                                                          0xFF495565,
                                                        ),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          IntrinsicWidth(
                                            child: IntrinsicHeight(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Oct 15, 2025",
                                                    style: TextStyle(
                                                      color: Color(0xFF697282),
                                                      fontSize: 14,
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
                                  InkWell(
                                    onTap: () {
                                      print('Pressed');
                                    },
                                    child: IntrinsicHeight(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                          color: Color(0xFFFFF1F2),
                                        ),
                                        padding: const EdgeInsets.only(
                                          top: 14,
                                          bottom: 14,
                                          left: 18,
                                          right: 18,
                                        ),
                                        margin: const EdgeInsets.only(
                                          bottom: 40,
                                        ),
                                        width: double.infinity,
                                        child: Row(
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                right: 16,
                                              ),
                                              width: 15,
                                              height: 15,
                                              child: Image.network(
                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/1amfho5y_expires_30_days.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Expanded(
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  "Asking for money to return the item",
                                                  style: TextStyle(
                                                    color: Color(0xFF354152),
                                                    fontSize: 14,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
