import 'package:flutter/material.dart';

import 'admin_lostitems1.dart';
import 'admin_founditems.dart';
import 'admin_claims.dart';
import 'admin_splash_user_contacted.dart';
import 'admin_splash_userwarned.dart';
import 'admin_deleteitemask.dart';

//connection to splash screens, warn and contact user

class AdminDashboard3UserReports extends StatefulWidget {
	const AdminDashboard3UserReports({super.key});
	@override
		AdminDashboard3UserReportsState createState() => AdminDashboard3UserReportsState();
	}
class AdminDashboard3UserReportsState extends State<AdminDashboard3UserReports> {
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
															padding: const EdgeInsets.only( left: 23, right: 23),
															margin: const EdgeInsets.only( bottom: 15),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( top: 47, bottom: 16),
																			width: double.infinity,
																			child: Row(
																				mainAxisAlignment: MainAxisAlignment.spaceBetween,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Text(
																										"Admin Dashboard 🛡️",
																										style: TextStyle(
																											color: Color(0xFFFFFFFF),
																											fontSize: 16,
																										),
																									),
																								]
																							),
																						),
																					),
																					Container(
																						width: 87,
																						height: 39,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/ykqkaz7r_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24),
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
																				]
																			),
																		),
																	),
																]
															),
														),
													),
													IntrinsicHeight(
														child: Container(
															margin: const EdgeInsets.only( bottom: 15, left: 33, right: 33),
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
																						color: Color(0x4D000000),
																						blurRadius: 2,
																						offset: Offset(0, 1),
																					),
																				],
																			),
																			padding: const EdgeInsets.only( top: 4, bottom: 4, left: 3, right: 3),
																			margin: const EdgeInsets.only( bottom: 21),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [

                                          //****GO BACK TO LOST ITEMS PAGE */
																					Expanded(
																						child: InkWell(
																							onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboard1LostItems()), 
                                                  );  
                                              
                                              
                                              }
                                              
                                              ,
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0x00000000),
																											width: 1,
																										),
																										borderRadius: BorderRadius.circular(10),
																										color: Color(0xFFFFFFFF),
																									),
																									padding: const EdgeInsets.symmetric(vertical: 4),
																									margin: const EdgeInsets.only( right: 1),
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
																										]
																									),
																								),
																							),
																						),
																					),

                                          //****GO BACK TO FOUND ITEMS PAGE */
																					Expanded(
																						child: InkWell(
																							onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboard2FoundItems()), 
                                                  );   
                                              
                                              
                                              
                                              },
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0x00000000),
																											width: 1,
																										),
																										borderRadius: BorderRadius.circular(10),
																									),
																									padding: const EdgeInsets.symmetric(vertical: 4),
																									margin: const EdgeInsets.only( right: 1),
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
																										]
																									),
																								),
																							),
																						),
																					),

                                          //*****GO TO CLAIMS PAGE  */
																					Expanded(
																						child: InkWell(
																							onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboardClaimScreen1()), 
                                                  );   
                                              
                                              
                                              },
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0x00000000),
																											width: 1,
																										),
																										borderRadius: BorderRadius.circular(10),
																									),
																									padding: const EdgeInsets.symmetric(vertical: 4),
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
																										]
																									),
																								),
																							),
																						),
																					),

                                          //ALREADY ON USER REPORTS PAGE 
																					Expanded(
																						child: InkWell(
																							onTap: () { print('Pressed'); },
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0x3B000000),
																											width: 1,
																										),
																										borderRadius: BorderRadius.circular(10),
																										color: Color(0xFFFFFFFF),
																										boxShadow: [
																											BoxShadow(
																												color: Color(0x26000000),
																												blurRadius: 4,
																												offset: Offset(0, 4),
																											),
																										],
																									),
																									padding: const EdgeInsets.symmetric(vertical: 4),
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
																			padding: const EdgeInsets.all(15),
																			margin: const EdgeInsets.only( bottom: 13, left: 4, right: 4),
																			width: double.infinity,
																			child: Row(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( right: 12),
																						width: 39,
																						height: 39,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/3ju2680m_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( bottom: 1),
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Text(
																															"User Misconduct Reports",
																															style: TextStyle(
																																color: Color(0xFFFFFFFF),
																																fontSize: 16,
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													padding: const EdgeInsets.only( right: 68),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"2 pending reports",
																																style: TextStyle(
																																	color: Color(0xFFFFFEFE),
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
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			padding: const EdgeInsets.only( bottom: 1),
																			margin: const EdgeInsets.only( bottom: 15, left: 4, right: 4),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
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
																							padding: const EdgeInsets.only( top: 16, bottom: 16, right: 21),
																							margin: const EdgeInsets.only( bottom: 12),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 21, left: 15),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 8),
																																child: Row(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( right: 23),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Set of Keys",
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
																																							color: Color(0xFFFFE4E6),
																																						),
																																						padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																						child: Column(
																																							crossAxisAlignment: CrossAxisAlignment.start,
																																							children: [
																																								Text(
																																									"Pending",
																																									style: TextStyle(
																																										color: Color(0xFFC70036),
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
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																child: Row(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( right: 17),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Reported User:",
																																								style: TextStyle(
																																									color: Color(0xFFEC003F),
																																									fontSize: 14,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Text(
																																			"emma_wilson",
																																			style: TextStyle(
																																				color: Color(0xFF495565),
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
																																margin: const EdgeInsets.only( bottom: 4),
																																child: Row(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( right: 14),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Reported By:",
																																								style: TextStyle(
																																									color: Color(0xFF354152),
																																									fontSize: 14,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Text(
																																			"amna1345",
																																			style: TextStyle(
																																				color: Color(0xFF495565),
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
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Text(
																																		"Oct 14, 2025",
																																		style: TextStyle(
																																			color: Color(0xFF697282),
																																			fontSize: 14,
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
																									InkWell(
																										onTap: () { print('Pressed'); },
																										child: IntrinsicHeight(
																											child: Container(
																												decoration: BoxDecoration(
																													borderRadius: BorderRadius.circular(10),
																													color: Color(0xFFFFF1F2),
																												),
																												padding: const EdgeInsets.only( top: 12, bottom: 12, left: 11, right: 11),
																												margin: const EdgeInsets.only( bottom: 13, left: 10),
																												width: double.infinity,
																												child: Row(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														Container(
																															margin: const EdgeInsets.only( right: 13),
																															width: 15,
																															height: 15,
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/tkzg7yoi_expires_30_days.png",
																																fit: BoxFit.fill,
																															)
																														),
																														Expanded(
																															child: Container(
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
																													]
																												),
																											),
																										),
																									),
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( bottom: 1),
																												margin: const EdgeInsets.only( left: 15),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	margin: const EdgeInsets.only( bottom: 8),
																																	child: Row(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [


                                                                      //CONTACT USER GOES TO CONTACT USER SPLASH SCREEN
																																			InkWell(
																																				onTap: () { Navigator.push(
                                                                            context,
                                                                            MaterialPageRoute(builder: (context) => const UserContactedSplashScreen()), 
                                                                          );

                                                                        
                                                                         },
																																				child: IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								border: Border.all(
																																									color: Color(0x1A000000),
																																									width: 1,
																																								),
																																								borderRadius: BorderRadius.circular(10),
																																								color: Color(0xFFFFFFFF),
																																								boxShadow: [
																																									BoxShadow(
																																										color: Color(0x26000000),
																																										blurRadius: 4,
																																										offset: Offset(0, 4),
																																									),
																																								],
																																							),
																																							padding: const EdgeInsets.only( top: 4, bottom: 4, left: 12, right: 12),
																																							margin: const EdgeInsets.only( right: 9),
																																							child: Row(
																																								children: [
																																									Container(
																																										decoration: BoxDecoration(
																																											borderRadius: BorderRadius.circular(10),
																																										),
																																										margin: const EdgeInsets.only( right: 10),
																																										width: 15,
																																										height: 15,
																																										child: ClipRRect(
																																											borderRadius: BorderRadius.circular(10),
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/6rjx3o3a_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										)
																																									),
																																									Text(
																																										"Contact User",
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
																																			),

                                                                      //*****USER WARNED FOR KEYS */
																																			InkWell(
																																				onTap: () { Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => const UserWarnedSplashScreen()), 
                                                                        );
 
                                                                        
                                                                        },
																																				child: IntrinsicWidth(
																																					child: IntrinsicHeight(
																																						child: Container(
																																							decoration: BoxDecoration(
																																								border: Border.all(
																																									color: Color(0x1A000000),
																																									width: 1,
																																								),
																																								borderRadius: BorderRadius.circular(10),
																																								color: Color(0xFFFFFFFF),
																																								boxShadow: [
																																									BoxShadow(
																																										color: Color(0x26000000),
																																										blurRadius: 4,
																																										offset: Offset(0, 4),
																																									),
																																								],
																																							),
																																							padding: const EdgeInsets.only( top: 4, bottom: 4, left: 12, right: 12),
																																							child: Row(
																																								children: [
																																									Container(
																																										decoration: BoxDecoration(
																																											borderRadius: BorderRadius.circular(10),
																																										),
																																										margin: const EdgeInsets.only( right: 10),
																																										width: 15,
																																										height: 15,
																																										child: ClipRRect(
																																											borderRadius: BorderRadius.circular(10),
																																											child: Image.network(
																																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/ao4v9te3_expires_30_days.png",
																																												fit: BoxFit.fill,
																																											)
																																										)
																																									),
																																									Text(
																																										"Warn User",
																																										style: TextStyle(
																																											color: Color(0xFFF54900),
																																											fontSize: 14,
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
																														),
																														InkWell(
																															onTap: () { print('Pressed'); },
																															child: IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		decoration: BoxDecoration(
																																			border: Border.all(
																																				color: Color(0x1A000000),
																																				width: 1,
																																			),
																																			borderRadius: BorderRadius.circular(10),
																																			color: Color(0xFFFFFFFF),
																																			boxShadow: [
																																				BoxShadow(
																																					color: Color(0x26000000),
																																					blurRadius: 4,
																																					offset: Offset(0, 4),
																																				),
																																			],
																																		),
																																		padding: const EdgeInsets.only( top: 4, bottom: 4, left: 12, right: 12),
																																		margin: const EdgeInsets.only( right: 130),
																																		child: Row(
																																			children: [
																																				Container(
																																					decoration: BoxDecoration(
																																						borderRadius: BorderRadius.circular(10),
																																					),
																																					margin: const EdgeInsets.only( right: 10),
																																					width: 15,
																																					height: 15,
																																					child: ClipRRect(
																																						borderRadius: BorderRadius.circular(10),
																																						child: Image.network(
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/3kdqb3ee_expires_30_days.png",
																																							fit: BoxFit.fill,
																																						)
																																					)
																																				),
																																				Text(
																																					"Delete Item",
																																					style: TextStyle(
																																						color: Color(0xFFEC003F),
																																						fontSize: 14,
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
																									),
																								]
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
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( top: 16, bottom: 10, left: 15, right: 15),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 8),
																																child: Row(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( right: 32),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Leather Wallet",
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
																																							color: Color(0xFFFFE4E6),
																																						),
																																						padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																						child: Column(
																																							crossAxisAlignment: CrossAxisAlignment.start,
																																							children: [
																																								Text(
																																									"Pending",
																																									style: TextStyle(
																																										color: Color(0xFFC70036),
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
																													),
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 4),
																																child: Row(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( right: 20),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Reported User:",
																																								style: TextStyle(
																																									color: Color(0xFFEC003F),
																																									fontSize: 14,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Text(
																																			"lisa_davis",
																																			style: TextStyle(
																																				color: Color(0xFF495565),
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
																																margin: const EdgeInsets.only( bottom: 3),
																																child: Row(
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					margin: const EdgeInsets.only( right: 20),
																																					child: Column(
																																						crossAxisAlignment: CrossAxisAlignment.start,
																																						children: [
																																							Text(
																																								"Reported By:",
																																								style: TextStyle(
																																									color: Color(0xFF354152),
																																									fontSize: 14,
																																								),
																																							),
																																						]
																																					),
																																				),
																																			),
																																		),
																																		Text(
																																			"Faseeha12",
																																			style: TextStyle(
																																				color: Color(0xFF495565),
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
																															child: Column(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Text(
																																		"Oct 15, 2025",
																																		style: TextStyle(
																																			color: Color(0xFF697282),
																																			fontSize: 14,
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
																									IntrinsicHeight(
																										child: Container(
																											decoration: BoxDecoration(
																												borderRadius: BorderRadius.circular(10),
																												color: Color(0xFFFFF1F2),
																											),
																											padding: const EdgeInsets.only( top: 12, bottom: 12, left: 11, right: 11),
																											margin: const EdgeInsets.only( bottom: 9, left: 16, right: 16),
																											width: double.infinity,
																											child: Row(
																												children: [
																													Container(
																														margin: const EdgeInsets.only( right: 4),
																														width: 15,
																														height: 15,
																														child: Image.network(
																															"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/3dn9roar_expires_30_days.png",
																															fit: BoxFit.fill,
																														)
																													),
																													Expanded(
																														child: Container(
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
																												]
																											),
																										),
																									),
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( bottom: 10, left: 16, right: 38),
																												width: double.infinity,
																												child: Row(
																													children: [

                                                            //*****CONTACT USER SPLASH SCREEN wallet */
																														InkWell(
																															onTap: () { Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => const UserContactedSplashScreen()), 
                                                                        ); 
                                                              
                                                              
                                                              },
																															child: IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		decoration: BoxDecoration(
																																			border: Border.all(
																																				color: Color(0x1A000000),
																																				width: 1,
																																			),
																																			borderRadius: BorderRadius.circular(10),
																																			color: Color(0xFFFFFFFF),
																																			boxShadow: [
																																				BoxShadow(
																																					color: Color(0x26000000),
																																					blurRadius: 4,
																																					offset: Offset(0, 4),
																																				),
																																			],
																																		),
																																		padding: const EdgeInsets.only( top: 4, bottom: 4, left: 11, right: 11),
																																		margin: const EdgeInsets.only( right: 24),
																																		child: Row(
																																			children: [
																																				Container(
																																					decoration: BoxDecoration(
																																						borderRadius: BorderRadius.circular(10),
																																					),
																																					margin: const EdgeInsets.only( right: 10),
																																					width: 15,
																																					height: 15,
																																					child: ClipRRect(
																																						borderRadius: BorderRadius.circular(10),
																																						child: Image.network(
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/pjrcw779_expires_30_days.png",
																																							fit: BoxFit.fill,
																																						)
																																					)
																																				),
																																				Text(
																																					"Contact User",
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
																														),

                                                            //*****WARN USER FOR WALLET */
																														InkWell(
																															onTap: () { Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(builder: (context) => const UserWarnedSplashScreen()), 
                                                                        ); 
                                                              
                                                              
                                                              },
																															child: IntrinsicWidth(
																																child: IntrinsicHeight(
																																	child: Container(
																																		decoration: BoxDecoration(
																																			border: Border.all(
																																				color: Color(0x1A000000),
																																				width: 1,
																																			),
																																			borderRadius: BorderRadius.circular(10),
																																			color: Color(0xFFFFFFFF),
																																			boxShadow: [
																																				BoxShadow(
																																					color: Color(0x26000000),
																																					blurRadius: 4,
																																					offset: Offset(0, 4),
																																				),
																																			],
																																		),
																																		padding: const EdgeInsets.only( top: 4, bottom: 4, left: 11, right: 11),
																																		child: Row(
																																			children: [
																																				Container(
																																					decoration: BoxDecoration(
																																						borderRadius: BorderRadius.circular(10),
																																					),
																																					margin: const EdgeInsets.only( right: 10),
																																					width: 15,
																																					height: 15,
																																					child: ClipRRect(
																																						borderRadius: BorderRadius.circular(10),
																																						child: Image.network(
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/zpw32fp7_expires_30_days.png",
																																							fit: BoxFit.fill,
																																						)
																																					)
																																				),
																																				Text(
																																					"Warn User",
																																					style: TextStyle(
																																						color: Color(0xFFF54900),
																																						fontSize: 14,
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
																									),

                                                //***GOES TO DELETE DISCLAIMER */
																									InkWell(
																										onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboardDeletingItem()), 
                                                  );
 
                                                    },
																										child: IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													decoration: BoxDecoration(
																														border: Border.all(
																															color: Color(0x1A000000),
																															width: 1,
																														),
																														borderRadius: BorderRadius.circular(10),
																														color: Color(0xFFFFFFFF),
																														boxShadow: [
																															BoxShadow(
																																color: Color(0x26000000),
																																blurRadius: 4,
																																offset: Offset(0, 4),
																															),
																														],
																													),
																													padding: const EdgeInsets.only( top: 4, bottom: 4, left: 11, right: 11),
																													margin: const EdgeInsets.only( bottom: 29, left: 23),
																													child: Row(
																														children: [
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(10),
																																),
																																margin: const EdgeInsets.only( right: 10),
																																width: 15,
																																height: 15,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(10),
																																	child: Image.network(
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/b5c8qbaw_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Text(
																																"Delete Item",
																																style: TextStyle(
																																	color: Color(0xFFEC003F),
																																	fontSize: 14,
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