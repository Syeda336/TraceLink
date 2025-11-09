import 'package:flutter/material.dart';

//admin can go to found , claims , user reports , view item , return item , delete item , go to logout screen
import 'admin_founditems.dart'; //go to found items
import 'admin_claims.dart'; // go to claims from top tab
import 'admin_user_reports.dart'; // go to user reports
import 'admin_viewitem1.dart'; // view the wallet
import 'admin_deleteitemask.dart'; //delete wallet goes to delete disclaimer
import 'admin_show_return.dart'; // click return and goes to returned screen
import 'admin_logout.dart'; // simply go to logout screen
import 'home.dart';

class AdminDashboard1LostItems extends StatefulWidget {
  const AdminDashboard1LostItems({super.key});
  @override
  AdminDashboard1LostItemsState createState() =>
      AdminDashboard1LostItemsState();
}

class AdminDashboard1LostItemsState extends State<AdminDashboard1LostItems> {
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
                              padding: const EdgeInsets.only(
                                top: 24,
                                bottom: 24,
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
                                        children: [
                                          Text(
                                            "Admin Dashboard 🛡️",
                                            style: TextStyle(
                                              color: Color(0xFFFFFFFF),
                                              fontSize: 16,
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              width: double.infinity,
                                              child: SizedBox(),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const HomeScreen(), // 👈 make sure HomePage exists in home.dart
                                                ),
                                              );
                                            },
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                right: 8,
                                              ),
                                              width: 39,
                                              height: 39,
                                              child: Image.network(
                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/plmub31e_expires_30_days.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),

                                          //****LOGOUT NAVIGATION GOES TO LOGOUT SCREEN */
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      const AdminDashboardLogoutConfirmation(),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 39,
                                              height: 39,
                                              child: Image.network(
                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/h66f5081_expires_30_days.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IntrinsicHeight(
                                    child: Container(
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
                              padding: const EdgeInsets.only(
                                top: 5,
                                bottom: 5,
                                left: 24,
                                right: 44,
                              ),
                              margin: const EdgeInsets.only(bottom: 47),
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
                                            color: Color(0x33000000),
                                            blurRadius: 2,
                                            offset: Offset(0, 1),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.only(
                                        left: 2,
                                        right: 2,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 25),
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                print('Pressed');
                                              },
                                              child: IntrinsicHeight(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: Color(0x33201616),
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
                                            //****ADDING LOST goes TO FOUND ITEMS TAB NAVIGATION */
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 5,
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

                                          //****NAVIGATION TO lost to  CLAIMS SCREEN */
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
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          10,
                                                        ),
                                                  ),
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        vertical: 5,
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

                                          //****LOST NAVIGATIONS TO USER REPORTS IN TAB LIST */
                                          Expanded(
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
                                                        vertical: 5,
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
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x1A000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(16),
                                      margin: const EdgeInsets.only(bottom: 13),
                                      width: double.infinity,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 16,
                                            ),
                                            width: 79,
                                            height: 79,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              child: Image.network(
                                                "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/ac8d4a9q_expires_30_days.png",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: IntrinsicHeight(
                                              child: Container(
                                                width: double.infinity,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    IntrinsicHeight(
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                              bottom: 7,
                                                            ),
                                                        width: double.infinity,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                                        fontSize:
                                                                            16,
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
                                                                        width:
                                                                            1,
                                                                      ),
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                            8,
                                                                          ),
                                                                      color: Color(
                                                                        0xFFF2E7FE,
                                                                      ),
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              3,
                                                                          bottom:
                                                                              3,
                                                                          left:
                                                                              11,
                                                                          right:
                                                                              11,
                                                                        ),
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          "Lost",
                                                                          style: TextStyle(
                                                                            color: Color(
                                                                              0xFF8200DA,
                                                                            ),
                                                                            fontSize:
                                                                                12,
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
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 7,
                                                            left: 14,
                                                          ),
                                                      child: Text(
                                                        "Black wallet with ID",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF495565,
                                                          ),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                    Container(
                                                      margin:
                                                          const EdgeInsets.only(
                                                            bottom: 6,
                                                            left: 4,
                                                          ),
                                                      child: Text(
                                                        "By: Panda123",
                                                        style: TextStyle(
                                                          color: Color(
                                                            0xFF697282,
                                                          ),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),

                                                    IntrinsicHeight(
                                                      child: Container(
                                                        padding:
                                                            const EdgeInsets.only(
                                                              right: 20,
                                                            ),
                                                        width: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IntrinsicHeight(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      bottom: 6,
                                                                    ),
                                                                width: double
                                                                    .infinity,
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    //**********ADDING VIEW WALLET NAVIGATION****** */
                                                                    GestureDetector(
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
                                                                              left: 11,
                                                                              right: 11,
                                                                            ),
                                                                            margin: const EdgeInsets.only(
                                                                              right: 8,
                                                                            ),

                                                                            child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                  ),
                                                                                  margin: const EdgeInsets.only(
                                                                                    top: 15,
                                                                                    bottom: 3,
                                                                                    right: 10,
                                                                                  ),
                                                                                  width: 13,
                                                                                  height: 9,
                                                                                  child: ClipRRect(
                                                                                    borderRadius: BorderRadius.circular(
                                                                                      10,
                                                                                    ),
                                                                                    child: Image.network(
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/9bv0b7t4_expires_30_days.png",
                                                                                      fit: BoxFit.fill,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                Container(
                                                                                  margin: const EdgeInsets.only(
                                                                                    top: 4,
                                                                                  ),
                                                                                  child: Text(
                                                                                    "View",
                                                                                    style: TextStyle(
                                                                                      color: Color(
                                                                                        0xFF0A0A0A,
                                                                                      ),
                                                                                      fontSize: 14,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),

                                                                    //******ADDING NAVIGATION FROM LOST TO RETURN WALLET***** */
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
                                                                                      "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/0lcrp95o_expires_30_days.png",
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

                                                            //****ADDING LOST ITEMS TO DELETE DISCLAIMER NAVIGATION */
                                                            InkWell(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) =>
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
                                                                        width:
                                                                            1,
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
                                                                          offset: Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              4,
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
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/chyjs3sx_expires_30_days.png",
                                                                              fit: BoxFit.fill,
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
                                            color: Color(0x1A000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      margin: const EdgeInsets.only(bottom: 13),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 16,
                                                left: 16,
                                                right: 16,
                                              ),
                                              width: double.infinity,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
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
                                                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/2dpswsva_expires_30_days.png",
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IntrinsicHeight(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      bottom: 8,
                                                                    ),
                                                                width: double
                                                                    .infinity,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    IntrinsicWidth(
                                                                      child: IntrinsicHeight(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "Red Backpack",
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
                                                                                0xFFF2E7FE,
                                                                              ),
                                                                            ),
                                                                            padding: const EdgeInsets.only(
                                                                              top: 3,
                                                                              bottom: 3,
                                                                              left: 10,
                                                                              right: 10,
                                                                            ),
                                                                            child: Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Lost",
                                                                                  style: TextStyle(
                                                                                    color: Color(
                                                                                      0xFF8200DA,
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
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                    bottom: 7,
                                                                    left: 3,
                                                                  ),
                                                              child: Text(
                                                                "red backpack with textbooks",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF495565,
                                                                  ),
                                                                  fontSize: 13,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                    left: 15,
                                                                  ),
                                                              child: Text(
                                                                "By: sara12asif",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF697282,
                                                                  ),
                                                                  fontSize: 14,
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
                                              margin: const EdgeInsets.only(
                                                bottom: 11,
                                              ),
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  IntrinsicWidth(
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                              right: 32,
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
                                                                        width:
                                                                            1,
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
                                                                          offset: Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              4,
                                                                          bottom:
                                                                              4,
                                                                          left:
                                                                              11,
                                                                          right:
                                                                              11,
                                                                        ),
                                                                    margin:
                                                                        const EdgeInsets.only(
                                                                          right:
                                                                              6,
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
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/kmefhybl_expires_30_days.png",
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
                                                                        width:
                                                                            1,
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
                                                                          offset: Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              4,
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
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/2cj8rn6f_expires_30_days.png",
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
                                                      color: Color(0x1A000000),
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
                                                      const EdgeInsets.only(
                                                        top: 4,
                                                        bottom: 4,
                                                        left: 11,
                                                        right: 11,
                                                      ),
                                                  margin: const EdgeInsets.only(
                                                    left: 111,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
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
                                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/ifn1bpbf_expires_30_days.png",
                                                            fit: BoxFit.fill,
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
                                        borderRadius: BorderRadius.circular(16),
                                        color: Color(0xFFFFFFFF),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0x1A000000),
                                            blurRadius: 4,
                                            offset: Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      width: double.infinity,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          IntrinsicHeight(
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                bottom: 16,
                                                left: 16,
                                                right: 16,
                                              ),
                                              width: double.infinity,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
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
                                                        "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/rhlrv2mg_expires_30_days.png",
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        width: double.infinity,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            IntrinsicHeight(
                                                              child: Container(
                                                                margin:
                                                                    const EdgeInsets.only(
                                                                      bottom: 8,
                                                                    ),
                                                                width: double
                                                                    .infinity,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    IntrinsicWidth(
                                                                      child: IntrinsicHeight(
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            Text(
                                                                              "MacBook Pro",
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
                                                                              top: 3,
                                                                              bottom: 3,
                                                                              left: 10,
                                                                              right: 10,
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
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                    bottom: 7,
                                                                    left: 12,
                                                                  ),
                                                              width: 145,
                                                              child: Text(
                                                                "Silver MacBook Pro 14-inch with stickers",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF495565,
                                                                  ),
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              margin:
                                                                  const EdgeInsets.only(
                                                                    left: 13,
                                                                  ),
                                                              child: Text(
                                                                "By: Ahmed Asim",
                                                                style: TextStyle(
                                                                  color: Color(
                                                                    0xFF697282,
                                                                  ),
                                                                  fontSize: 14,
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
                                              margin: const EdgeInsets.only(
                                                bottom: 11,
                                              ),
                                              width: double.infinity,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  IntrinsicWidth(
                                                    child: IntrinsicHeight(
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.only(
                                                              right: 37,
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
                                                                        width:
                                                                            1,
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
                                                                          offset: Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              4,
                                                                          bottom:
                                                                              4,
                                                                          left:
                                                                              11,
                                                                          right:
                                                                              11,
                                                                        ),
                                                                    margin:
                                                                        const EdgeInsets.only(
                                                                          right:
                                                                              6,
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
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/skpiovb1_expires_30_days.png",
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
                                                                        width:
                                                                            1,
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
                                                                          offset: Offset(
                                                                            0,
                                                                            4,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    padding:
                                                                        const EdgeInsets.only(
                                                                          top:
                                                                              4,
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
                                                                              "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/bdvdgu2f_expires_30_days.png",
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
                                                      color: Color(0x1A000000),
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
                                                      const EdgeInsets.only(
                                                        top: 4,
                                                        bottom: 4,
                                                        left: 11,
                                                        right: 11,
                                                      ),
                                                  margin: const EdgeInsets.only(
                                                    left: 106,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        decoration: BoxDecoration(
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
                                                            "https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/uj4n2qgl_expires_30_days.png",
                                                            fit: BoxFit.fill,
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
