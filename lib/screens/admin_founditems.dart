import 'package:flutter/material.dart';

//can go back to lost items screen , can go to claims , user reports, view / return/ delete wallet
import 'admin_lostitems1.dart';
import 'admin_claims.dart';
import 'admin_user_reports.dart';
import 'admin_viewitem1.dart'; //view wallet
import 'admin_deleteitemask.dart';
import 'admin_show_return.dart';

class AdminDashboard2FoundItems extends StatefulWidget {
  const AdminDashboard2FoundItems({super.key});
  @override
  AdminDashboard2FoundItemsState createState() =>
      AdminDashboard2FoundItemsState();
}

class AdminDashboard2FoundItemsState extends State<AdminDashboard2FoundItems> {
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
                              margin: const EdgeInsets.only(bottom: 15),
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
                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/rb00e6en_expires_30_days.png",
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
                              margin: const EdgeInsets.only(
                                bottom: 16,
                                left: 37,
                                right: 37,
                              ),
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IntrinsicHeight(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(14),
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x40000000),
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
                                      margin: const EdgeInsets.only(bottom: 25),
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            //****GO  TO LOST ITEMS PAGE  */
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
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
                                                          color: Color(
                                                            0xFF0A0A0A,
                                                          ),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                    color: Color(0xFFFFFFFF),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(
                                                          0x26000000,
                                                        ),
                                                        blurRadius: 4,
                                                        offset: Offset(0, 4),
                                                      ),
                                                    ],
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
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
                                                          color: Color(
                                                            0xFF0A0A0A,
                                                          ),
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
                                            //***go to claims page  */
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Claims",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF0A0A0A,
                                                          ),
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
                                            //****GO TO USER REPORTS */
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const AdminDashboard3UserReports(),
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 4,
                                                      ),
                                                  width: double.infinity,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Reports",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF0A0A0A,
                                                          ),
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
                                      margin: const EdgeInsets.only(bottom: 24),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Color(0xFFFFFFFF),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x40000000),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                              margin: const EdgeInsets.only(
                                                bottom: 13,
                                              ),
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 8,
                                                            left: 16,
                                                            right: 16,
                                                          ),
                                                      width: double.infinity,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                ),
                                                            margin:
                                                                const EdgeInsets.only(
                                                                  right: 16,
                                                                ),
                                                            width: 79,
                                                            height: 79,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              child: Image.network(
                                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/wtyz4s4g_expires_30_days.png",
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: IntrinsicHeight(
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    IntrinsicHeight(
                                                                      child: Container(
                                                                        margin: const EdgeInsets.only(
                                                                          bottom:
                                                                              8,
                                                                        ),
                                                                        width: double
                                                                            .infinity,
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            IntrinsicWidth(
                                                                              child: IntrinsicHeight(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                print(
                                                                                  'Pressed',
                                                                                );
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
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        8,
                                                                                      ),
                                                                                      color: Color(
                                                                                        0xFFDCFCE7,
                                                                                      ),
                                                                                    ),
                                                                                    padding: const EdgeInsets.only(
                                                                                      top: 2,
                                                                                      bottom: 2,
                                                                                      left: 9,
                                                                                      right: 9,
                                                                                    ),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Found",
                                                                                          style: TextStyle(
                                                                                            color: Color(
                                                                                              0xFF008235,
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
                                                                    IntrinsicHeight(
                                                                      child: Container(
                                                                        margin: const EdgeInsets.only(
                                                                          bottom:
                                                                              5,
                                                                        ),
                                                                        width: double
                                                                            .infinity,
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              "Set of keys with blue keychain",
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
                                                                    IntrinsicWidth(
                                                                      child: IntrinsicHeight(
                                                                        child: Container(
                                                                          margin: const EdgeInsets.only(
                                                                            left:
                                                                                1,
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "By: ali_aaaa12",
                                                                                style: TextStyle(
                                                                                  color: Color(
                                                                                    0xFF697282,
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 13,
                                                          ),
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          IntrinsicWidth(
                                                            child: IntrinsicHeight(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      right: 22,
                                                                    ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        print(
                                                                          'Pressed',
                                                                        );
                                                                      },
                                                                      child: IntrinsicWidth(
                                                                        child: IntrinsicHeight(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Color(
                                                                                  0x1A000000,
                                                                                ),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              color: Color(
                                                                                0xFFFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color(
                                                                                    0x26000000,
                                                                                  ),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(
                                                                                    0,
                                                                                    4,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            padding: const EdgeInsets.only(
                                                                              top: 4,
                                                                              bottom: 4,
                                                                              left: 11,
                                                                              right: 11,
                                                                            ),
                                                                            margin: const EdgeInsets.only(
                                                                              right: 18,
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  margin: const EdgeInsets.only(
                                                                                    right: 10,
                                                                                  ),
                                                                                  width: 15,
                                                                                  height: 15,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/sevf3rea_expires_30_days.png",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "View",
                                                                                  style: TextStyle(
                                                                                    color: Color(
                                                                                      0xFF0A0A0A,
                                                                                    ),
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        print(
                                                                          'Pressed',
                                                                        );
                                                                      },
                                                                      child: IntrinsicWidth(
                                                                        child: IntrinsicHeight(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Color(
                                                                                  0x1A000000,
                                                                                ),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              color: Color(
                                                                                0xFFFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color(
                                                                                    0x26000000,
                                                                                  ),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(
                                                                                    0,
                                                                                    4,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            padding: const EdgeInsets.only(
                                                                              top: 4,
                                                                              bottom: 4,
                                                                              left: 11,
                                                                              right: 11,
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  margin: const EdgeInsets.only(
                                                                                    right: 10,
                                                                                  ),
                                                                                  width: 15,
                                                                                  height: 15,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/3ezwzwt2_expires_30_days.png",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "Return",
                                                                                  style: TextStyle(
                                                                                    color: Color(
                                                                                      0xFF0A0A0A,
                                                                                    ),
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
                                                                0x1A000000,
                                                              ),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            color: Color(
                                                              0xFFFFFFFF,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                  0x26000000,
                                                                ),
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                  0,
                                                                  4,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 4,
                                                                bottom: 4,
                                                                left: 11,
                                                                right: 11,
                                                              ),
                                                          margin:
                                                              const EdgeInsets.only(
                                                                left: 108,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                    ),
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      right: 10,
                                                                    ),
                                                                width: 15,
                                                                height: 15,
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                  child: Image.network(
                                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/viv3nnzr_expires_30_days.png",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                "Delete",
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Color(0xFFFFFFFF),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x40000000),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 11,
                                                  ),
                                              margin: const EdgeInsets.only(
                                                bottom: 13,
                                              ),
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  IntrinsicHeight(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 16,
                                                            left: 16,
                                                            right: 16,
                                                          ),
                                                      width: double.infinity,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                ),
                                                            margin:
                                                                const EdgeInsets.only(
                                                                  right: 16,
                                                                ),
                                                            width: 79,
                                                            height: 79,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              child: Image.network(
                                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/yvsi7wob_expires_30_days.png",
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: IntrinsicHeight(
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    IntrinsicHeight(
                                                                      child: Container(
                                                                        margin: const EdgeInsets.only(
                                                                          bottom:
                                                                              8,
                                                                        ),
                                                                        width: double
                                                                            .infinity,
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            IntrinsicWidth(
                                                                              child: IntrinsicHeight(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                                                print(
                                                                                  'Pressed',
                                                                                );
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
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        8,
                                                                                      ),
                                                                                      color: Color(
                                                                                        0xFFDCFCE7,
                                                                                      ),
                                                                                    ),
                                                                                    padding: const EdgeInsets.only(
                                                                                      top: 2,
                                                                                      bottom: 2,
                                                                                      left: 9,
                                                                                      right: 9,
                                                                                    ),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Found",
                                                                                          style: TextStyle(
                                                                                            color: Color(
                                                                                              0xFF008235,
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
                                                                            bottom:
                                                                                5,
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "leather wallet black has ID",
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
                                                                            left:
                                                                                1,
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "By: lisa_davis",
                                                                                style: TextStyle(
                                                                                  color: Color(
                                                                                    0xFF697282,
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 6,
                                                          ),
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          IntrinsicWidth(
                                                            child: IntrinsicHeight(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      right: 16,
                                                                    ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    //*****VIEW THE LEATHER WALLET  */
                                                                    InkWell(
                                                                      onTap: () {
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (
                                                                                  context,
                                                                                ) => const AdminDashboard1ViewItem(),
                                                                          ),
                                                                        );
                                                                      },
                                                                      child: IntrinsicWidth(
                                                                        child: IntrinsicHeight(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Color(
                                                                                  0x1A000000,
                                                                                ),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              color: Color(
                                                                                0xFFFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color(
                                                                                    0x26000000,
                                                                                  ),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(
                                                                                    0,
                                                                                    4,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            padding: const EdgeInsets.only(
                                                                              top: 4,
                                                                              bottom: 4,
                                                                              left: 11,
                                                                              right: 11,
                                                                            ),
                                                                            margin: const EdgeInsets.only(
                                                                              right: 24,
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  margin: const EdgeInsets.only(
                                                                                    right: 10,
                                                                                  ),
                                                                                  width: 15,
                                                                                  height: 15,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/3m5kestp_expires_30_days.png",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "View",
                                                                                  style: TextStyle(
                                                                                    color: Color(
                                                                                      0xFF0A0A0A,
                                                                                    ),
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    //****GOES TO RETURN SCREEN WHERE WALLET IS RETURNED **** */
                                                                    InkWell(
                                                                      onTap: () {
                                                                        Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                            builder:
                                                                                (
                                                                                  context,
                                                                                ) => const AdminDashboard2ReturnedItemShow(),
                                                                          ),
                                                                        );
                                                                      },

                                                                      child: IntrinsicWidth(
                                                                        child: IntrinsicHeight(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Color(
                                                                                  0x1A000000,
                                                                                ),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              color: Color(
                                                                                0xFFFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color(
                                                                                    0x26000000,
                                                                                  ),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(
                                                                                    0,
                                                                                    4,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            padding: const EdgeInsets.only(
                                                                              top: 4,
                                                                              bottom: 4,
                                                                              left: 11,
                                                                              right: 11,
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  margin: const EdgeInsets.only(
                                                                                    right: 10,
                                                                                  ),
                                                                                  width: 15,
                                                                                  height: 15,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/br1ocnrb_expires_30_days.png",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "Return",
                                                                                  style: TextStyle(
                                                                                    color: Color(
                                                                                      0xFF0A0A0A,
                                                                                    ),
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
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  //****GO TO DELETE DISCLAIMER PAGE FOR WALLET */
                                                  InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              const AdminDashboardDeletingItem(),
                                                        ),
                                                      );
                                                    },

                                                    child: IntrinsicWidth(
                                                      child: IntrinsicHeight(
                                                        child: Container(
                                                          decoration: BoxDecoration(
                                                            border: Border.all(
                                                              color: Color(
                                                                0x1A000000,
                                                              ),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  10,
                                                                ),
                                                            color: Color(
                                                              0xFFFFFFFF,
                                                            ),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Color(
                                                                  0x26000000,
                                                                ),
                                                                blurRadius: 4,
                                                                offset: Offset(
                                                                  0,
                                                                  4,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          padding:
                                                              const EdgeInsets.only(
                                                                top: 4,
                                                                bottom: 4,
                                                                left: 11,
                                                                right: 11,
                                                              ),
                                                          margin:
                                                              const EdgeInsets.only(
                                                                left: 103,
                                                              ),
                                                          child: Row(
                                                            children: [
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                    ),
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      right: 10,
                                                                    ),
                                                                width: 15,
                                                                height: 15,
                                                                child: ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        10,
                                                                      ),
                                                                  child: Image.network(
                                                                    "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/rtj3u1o7_expires_30_days.png",
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                "Delete",
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
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          IntrinsicHeight(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                color: Color(0xFFFFFFFF),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Color(0x40000000),
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
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
                                                      margin:
                                                          const EdgeInsets.all(
                                                            16,
                                                          ),
                                                      width: double.infinity,
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        16,
                                                                      ),
                                                                ),
                                                            margin:
                                                                const EdgeInsets.only(
                                                                  right: 16,
                                                                ),
                                                            width: 79,
                                                            height: 79,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    16,
                                                                  ),
                                                              child: Image.network(
                                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/hzve1899_expires_30_days.png",
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: IntrinsicHeight(
                                                              child: SizedBox(
                                                                width: double
                                                                    .infinity,
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    IntrinsicHeight(
                                                                      child: Container(
                                                                        margin: const EdgeInsets.only(
                                                                          bottom:
                                                                              8,
                                                                        ),
                                                                        width: double
                                                                            .infinity,
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            IntrinsicWidth(
                                                                              child: IntrinsicHeight(
                                                                                child: Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Text(
                                                                                      "Water Bottle",
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
                                                                                print(
                                                                                  'Pressed',
                                                                                );
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
                                                                                      borderRadius: BorderRadius.circular(
                                                                                        8,
                                                                                      ),
                                                                                      color: Color(
                                                                                        0xFFDBEAFE,
                                                                                      ),
                                                                                    ),
                                                                                    padding: const EdgeInsets.only(
                                                                                      top: 2,
                                                                                      bottom: 2,
                                                                                      left: 9,
                                                                                      right: 9,
                                                                                    ),
                                                                                    child: Column(
                                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                                      children: [
                                                                                        Text(
                                                                                          "Returned",
                                                                                          style: TextStyle(
                                                                                            color: Color(
                                                                                              0xFF1347E5,
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
                                                                            bottom:
                                                                                5,
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "Pink water bottle with name tag",
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
                                                                            left:
                                                                                1,
                                                                          ),
                                                                          child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "By: Faseeha Siddiqui",
                                                                                style: TextStyle(
                                                                                  color: Color(
                                                                                    0xFF697282,
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
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 8,
                                                          ),
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          IntrinsicWidth(
                                                            child: IntrinsicHeight(
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  color: Color(
                                                                    0xFFFFFFFF,
                                                                  ),
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Color(
                                                                        0x40000000,
                                                                      ),
                                                                      blurRadius:
                                                                          4,
                                                                      offset:
                                                                          Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      right: 22,
                                                                    ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    InkWell(
                                                                      onTap: () {
                                                                        print(
                                                                          'Pressed',
                                                                        );
                                                                      },
                                                                      child: IntrinsicWidth(
                                                                        child: IntrinsicHeight(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Color(
                                                                                  0x1A000000,
                                                                                ),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              color: Color(
                                                                                0xFFFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color(
                                                                                    0x26000000,
                                                                                  ),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(
                                                                                    0,
                                                                                    4,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            padding: const EdgeInsets.only(
                                                                              top: 4,
                                                                              bottom: 4,
                                                                              left: 11,
                                                                              right: 11,
                                                                            ),
                                                                            margin: const EdgeInsets.only(
                                                                              right: 18,
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  margin: const EdgeInsets.only(
                                                                                    right: 10,
                                                                                  ),
                                                                                  width: 15,
                                                                                  height: 15,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/adorm36d_expires_30_days.png",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "View",
                                                                                  style: TextStyle(
                                                                                    color: Color(
                                                                                      0xFF0A0A0A,
                                                                                    ),
                                                                                    fontSize: 14,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    InkWell(
                                                                      onTap: () {
                                                                        print(
                                                                          'Pressed',
                                                                        );
                                                                      },
                                                                      child: IntrinsicWidth(
                                                                        child: IntrinsicHeight(
                                                                          child: Container(
                                                                            decoration: BoxDecoration(
                                                                              border: Border.all(
                                                                                color: Color(
                                                                                  0x1A000000,
                                                                                ),
                                                                                width: 1,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(
                                                                                10,
                                                                              ),
                                                                              color: Color(
                                                                                0xFFFFFFFF,
                                                                              ),
                                                                              boxShadow: [
                                                                                BoxShadow(
                                                                                  color: Color(
                                                                                    0x26000000,
                                                                                  ),
                                                                                  blurRadius: 4,
                                                                                  offset: Offset(
                                                                                    0,
                                                                                    4,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            padding: const EdgeInsets.only(
                                                                              top: 4,
                                                                              bottom: 4,
                                                                              left: 11,
                                                                              right: 11,
                                                                            ),
                                                                            child: Row(
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  margin: const EdgeInsets.only(
                                                                                    right: 10,
                                                                                  ),
                                                                                  width: 15,
                                                                                  height: 15,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/w5jbycc9_expires_30_days.png",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                Text(
                                                                                  "Return",
                                                                                  style: TextStyle(
                                                                                    color: Color(
                                                                                      0xFF0A0A0A,
                                                                                    ),
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
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  IntrinsicHeight(
                                                    child: Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 5,
                                                          ),
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
                                                                    border: Border.all(
                                                                      color: Color(
                                                                        0x1A000000,
                                                                      ),
                                                                      width: 1,
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                          10,
                                                                        ),
                                                                    color: Color(
                                                                      0xFFFFFFFF,
                                                                    ),
                                                                    boxShadow: [
                                                                      BoxShadow(
                                                                        color: Color(
                                                                          0x26000000,
                                                                        ),
                                                                        blurRadius:
                                                                            4,
                                                                        offset:
                                                                            Offset(
                                                                              0,
                                                                              4,
                                                                            ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  padding:
                                                                      const EdgeInsets.only(
                                                                        top: 4,
                                                                        bottom:
                                                                            4,
                                                                        left:
                                                                            11,
                                                                        right:
                                                                            11,
                                                                      ),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                        ),
                                                                        margin: const EdgeInsets.only(
                                                                          right:
                                                                              10,
                                                                        ),
                                                                        width:
                                                                            15,
                                                                        height:
                                                                            15,
                                                                        child: ClipRRect(
                                                                          borderRadius: BorderRadius.circular(
                                                                            10,
                                                                          ),
                                                                          child: Image.network(
                                                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/bdps73t4_expires_30_days.png",
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        "Delete",
                                                                        style: TextStyle(
                                                                          color: Color(
                                                                            0xFFEC003F,
                                                                          ),
                                                                          fontSize:
                                                                              14,
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
