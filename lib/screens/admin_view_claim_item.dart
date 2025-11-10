import 'package:flutter/material.dart';

import 'admin_del_claim_ask.dart';

//wallet return shown but not keys , admin can delete claim , go back to claims screen by pressing X

class AdminDashboardClaimViewItemScreen2 extends StatefulWidget {
	const AdminDashboardClaimViewItemScreen2({super.key});
	@override
		AdminDashboardClaimViewItemScreen2State createState() => AdminDashboardClaimViewItemScreen2State();
	}
class AdminDashboardClaimViewItemScreen2State extends State<AdminDashboardClaimViewItemScreen2> {
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
															color: Color(0x80000000),
															padding: const EdgeInsets.symmetric(vertical: 85),
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
																				color: Color(0xFFFFFFFF),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x1A000000),
																						blurRadius: 6,
																						offset: Offset(0, 4),
																					),
																				],
																			),
																			padding: const EdgeInsets.symmetric(vertical: 21),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8, left: 17, right: 17),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									SizedBox(
																										width: 15,
																										height: 16,
																										child: SizedBox(),
																									),
																									Container(
																										margin: const EdgeInsets.only( top: 8),
																										child: Text(
																											"Claim Details",
																											style: TextStyle(
																												color: Color(0xFF0A0A0A),
																												fontSize: 18,
																												fontWeight: FontWeight.bold,
																											),
																										),
																									),

                                                //*****go back to claims screen** */
                                                GestureDetector( 
                                                      onTap: () {
                                                        // This command goes BACK to the previous screen
                                                        Navigator.pop(context);
                                                      },

																									child: IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													Container(
																														decoration: BoxDecoration(
																															borderRadius: BorderRadius.circular(2),
																														),
																														width: 15,
																														height: 15,
																														child: ClipRRect(
																															borderRadius: BorderRadius.circular(2),
                                                              //CROSS BUTTON
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/jv1udp3f_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														)
																													),
																												]
																											),
																										),
																									),
                                                ),
																								],
																							),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( bottom: 17, left: 25),
																						child: Text(
																							"Review the claim information",
																							style: TextStyle(
																								color: Color(0xFF717182),
																								fontSize: 14,
																							),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( bottom: 16, left: 25, right: 25),
																						height: 191,
																						width: double.infinity,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/whuys4t8_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8, left: 25, right: 25),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Set of Keys",
																										style: TextStyle(
																											color: Color(0xFF101727),
																											fontSize: 16,
																										),
																									),
																									InkWell(
																										onTap: () { print('Pressed'); },
																										child: IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0x00000000),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(8),
																														color: Color(0xFFFEF3C6),
																													),
																													padding: const EdgeInsets.only( top: 2, bottom: 2, left: 9, right: 9),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Pending",
																																style: TextStyle(
																																	color: Color(0xFFBB4D00),
																																	fontSize: 12,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							decoration: BoxDecoration(
																								border: Border.all(
																									color: Color(0xFFE9D4FF),
																									width: 1,
																								),
																								borderRadius: BorderRadius.circular(14),
																								color: Color(0xFFFAF5FF),
																							),
																							padding: const EdgeInsets.only( top: 3, bottom: 3, right: 37),
																							margin: const EdgeInsets.only( bottom: 16, left: 25, right: 25),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										margin: const EdgeInsets.only( bottom: 3, left: 13),
																										child: Text(
																											"Claim Reason:",
																											style: TextStyle(
																												color: Color(0xFF59168B),
																												fontSize: 14,
																												fontWeight: FontWeight.bold,
																											),
																										),
																									),
																									Container(
																										margin: const EdgeInsets.only( left: 23),
																										width: double.infinity,
																										child: Text(
																											"These are my dorm keys with a blue keychain that has my initials AB",
																											style: TextStyle(
																												color: Color(0xFF59168B),
																												fontSize: 14,
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 1, left: 25),
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 107),
																											child: Text(
																												"Claimed By",
																												style: TextStyle(
																													color: Color(0xFF697282),
																													fontSize: 14,
																												),
																											),
																										),
																										Text(
																											"Found By",
																											style: TextStyle(
																												color: Color(0xFF697282),
																												fontSize: 14,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 13, left: 25),
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 91),
																											child: Text(
																												"amaa_25jan",
																												style: TextStyle(
																													color: Color(0xFF101727),
																													fontSize: 16,
																												),
																											),
																										),
																										Text(
																											"emma_wilson",
																											style: TextStyle(
																												color: Color(0xFF101727),
																												fontSize: 16,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( bottom: 1, left: 25),
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 85),
																											child: Text(
																												"Owner Contact",
																												style: TextStyle(
																													color: Color(0xFF697282),
																													fontSize: 14,
																												),
																											),
																										),
																										Text(
																											"Finder Contact",
																											style: TextStyle(
																												color: Color(0xFF697282),
																												fontSize: 14,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 13, left: 25, right: 39),
																							width: double.infinity,
																							child: Row(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Expanded(
																										child: Container(
																											margin: const EdgeInsets.only( right: 33),
																											width: double.infinity,
																											child: Text(
																												"amna.b@university.edu",
																												style: TextStyle(
																													color: Color(0xFF101727),
																													fontSize: 14,
																												),
																											),
																										),
																									),
																									Expanded(
																										child: SizedBox(
																											width: double.infinity,
																											child: Text(
																												"emma.w@university.edu",
																												style: TextStyle(
																													color: Color(0xFF101727),
																													fontSize: 14,
																												),
																											),
																										),
																									),
																								]
																							),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( bottom: 1, left: 25),
																						child: Text(
																							"Date",
																							style: TextStyle(
																								color: Color(0xFF697282),
																								fontSize: 14,
																							),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( bottom: 16, left: 25),
																						child: Text(
																							"Oct 14, 2025",
																							style: TextStyle(
																								color: Color(0xFF101727),
																								fontSize: 16,
																							),
																						),
																					),
																					InkWell(
																						onTap: () { print('Pressed'); },
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									border: Border.all(
																										color: Color(0x1A000000),
																										width: 1,
																									),
																									borderRadius: BorderRadius.circular(8),
																									color: Color(0xFFFFFFFF),
																									boxShadow: [
																										BoxShadow(
																											color: Color(0x40000000),
																											blurRadius: 4,
																											offset: Offset(0, 4),
																										),
																									],
																								),
																								padding: const EdgeInsets.symmetric(vertical: 6),
																								margin: const EdgeInsets.only( bottom: 9, left: 25, right: 25),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.center,
																									children: [
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(8),
																											),
																											margin: const EdgeInsets.only( right: 16),
																											width: 15,
																											height: 15,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(8),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/6lnbkq3c_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										Text(
																											"Mark as Returned",
																											style: TextStyle(
																												color: Color(0xFF0A0A0A),
																												fontSize: 14,
																											),
																										),
																									]
																								),
																							),
																						),
																					),

                                          //**************DELETE CLAIM DISCLAIMER */
																					InkWell(
																						onTap: () {Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboardDeleteClaim()), 
                                                  );
 
                                            
                                            },
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(8),
																									color: Color(0xFFD4183D),
																									boxShadow: [
																										BoxShadow(
																											color: Color(0x40000000),
																											blurRadius: 4,
																											offset: Offset(0, 4),
																										),
																									],
																								),
																								padding: const EdgeInsets.symmetric(vertical: 6),
																								margin: const EdgeInsets.symmetric(horizontal: 25),
																								width: double.infinity,
																								child: Row(
																									mainAxisAlignment: MainAxisAlignment.center,
																									children: [
																										Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(8),
																											),
																											margin: const EdgeInsets.only( right: 16),
																											width: 15,
																											height: 15,
																											child: ClipRRect(
																												borderRadius: BorderRadius.circular(8),
																												child: Image.network(
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/pu4wpyo8_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										Text(
																											"Delete Claim",
																											style: TextStyle(
																												color: Color(0xFFFFFFFF),
																												fontSize: 14,
																											),
																										),
																									]
																								),
																							),
																						),
																					),
																				]
																			),
																		),
																	),
																]
															),
														),
													),
												],
											)
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