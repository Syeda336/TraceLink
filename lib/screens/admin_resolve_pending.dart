import 'package:flutter/material.dart';

//resolve pending: admin can delete the wallet , mark as resolved for both items , goes to resolve screen
import 'admin_deleteitemask.dart';
import 'admin_resolved_reports.dart';
import 'admin_claims.dart';
import 'admin_founditems.dart';
import 'admin_lostitems1.dart';
import 'admin_logout.dart';

class AdminDashboardResolvePendingUserReport extends StatefulWidget {
	const AdminDashboardResolvePendingUserReport({super.key});
	@override
		AdminDashboardResolvePendingUserReportState createState() => AdminDashboardResolvePendingUserReportState();
	}
class AdminDashboardResolvePendingUserReportState extends State<AdminDashboardResolvePendingUserReport> {
	String textField1 = '';
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
																					Expanded(
																						child: Container(
																							width: double.infinity,
																							child: SizedBox(),
																						),
																					),

                                        /****NAVIGATION GOES TO home page aka lost items  */

                                         GestureDetector( 
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboard1LostItems()), 
                                                  );
                                              },
                                          child: Container(
																						margin: const EdgeInsets.only( right: 22),
																						width: 39,
																						height: 39,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/2myabi3m_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
                                         ),

                                          //****LOGOUT NAVIGATION GOES TO LOGOUT SCREEN */

                                         GestureDetector( 
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboardLogoutConfirmation()), 
                                                  );
                                              },
																					child: Container(
																						width: 39,
																						height: 39,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/gul2japc_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
                                         ),
																				],

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
															margin: const EdgeInsets.only( bottom: 21, left: 33, right: 33),
															width: double.infinity,
															child: Row(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [

                                  //***GO TO LOST ITEMS PAGE */
																	Expanded(
																		child: InkWell(
																			onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboard1LostItems()), 
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

                                  //****GO TO FOUND ITEMS PAGE  */
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

                                  //***GO TO CLAIMS PAGE */
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
															margin: const EdgeInsets.only( bottom: 13, left: 37, right: 25),
															width: double.infinity,
															child: Row(
																children: [
																	Container(
																		margin: const EdgeInsets.only( right: 12),
																		width: 39,
																		height: 39,
																		child: Image.network(
																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/1qbcokd8_expires_30_days.png",
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
															margin: const EdgeInsets.only( bottom: 30, left: 37, right: 25),
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
																			padding: const EdgeInsets.only( top: 15, bottom: 15, left: 9, right: 23),
																			margin: const EdgeInsets.only( bottom: 12),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 21),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 8),
																											width: double.infinity,
																											child: Row(
																												mainAxisAlignment: MainAxisAlignment.spaceBetween,
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicWidth(
																														child: IntrinsicHeight(
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
																																		color: Color(0xFFB6DEF2),
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 7, right: 7),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"Resolve Pending",
																																				style: TextStyle(
																																					color: Color(0xFF3020C5),
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
																																	margin: const EdgeInsets.only( right: 16),
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
																																	margin: const EdgeInsets.only( right: 13),
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
																								padding: const EdgeInsets.all(12),
																								margin: const EdgeInsets.only( bottom: 8),
																								width: double.infinity,
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 13),
																											width: 15,
																											height: 15,
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/c52lql8l_expires_30_days.png",
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
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 10),
																							width: double.infinity,
																							child: Row(
																								children: [
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
																													padding: const EdgeInsets.only( top: 1, bottom: 1, left: 12, right: 12),
																													margin: const EdgeInsets.only( right: 14),
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/ql3lz6x6_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Text(
																																"Contact User",
																																style: TextStyle(
																																	color: Color(0xFFBA9D91),
																																	fontSize: 14,
																																),
																															),
																														]
																													),
																												),
																											),
																										),
																									),
																									Expanded(
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
																												width: double.infinity,
																												child: Row(
																													children: [
																														Container(
																															decoration: BoxDecoration(
																																borderRadius: BorderRadius.circular(10),
																															),
																															margin: const EdgeInsets.only( left: 12),
																															width: 15,
																															height: 15,
																															child: ClipRRect(
																																borderRadius: BorderRadius.circular(10),
																																child: Image.network(
																																	"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/022dzced_expires_30_days.png",
																																	fit: BoxFit.fill,
																																)
																															)
																														),
																														
                                                            /*Expanded(
																															child: Container(
																																width: double.infinity,
																																child: SizedBox(),
																															),
																														), */

																														Expanded(
																															child: IntrinsicHeight(
																																child: Container(
																																	alignment: Alignment.center,
																																	padding: const EdgeInsets.symmetric(vertical: 6),
																																	margin: const EdgeInsets.only( right: 4),
																																	width: double.infinity,
																																	child: 
                                                                  TextField(
																																		style: TextStyle(
																																			color: Color(0xFFBA9D91),
																																			fontSize: 14,
																																		),
																																		onChanged: (value) { 
																																			setState(() { textField1 = value; });
																																		},
																																		decoration: InputDecoration(
																																			hintText: "Warn User",
																																			isDense: true,
																																			contentPadding: EdgeInsets.symmetric(vertical: 0),
																																			border: InputBorder.none,
																																		),
																																	),
																																),
																															),
																														),
																														//Expanded(
																															//child: Container(
																																//width: double.infinity,
																																//child: SizedBox(),
																															//),
																														//),
																													],
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
																							width: double.infinity,
																							child: Row(
																								children: [
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
																													margin: const EdgeInsets.only( right: 14),
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/9i41dsrg_expires_30_days.png",
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

                                                  //***Mark as resolved Button goes to resolved screen */


																									Expanded(
																										child: InkWell(
																											onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboardAfterWarningUser()), 
                                                  );    
                                                      
                                                      },
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
																													padding: const EdgeInsets.only( top: 6, bottom: 6, left: 8, right: 8),
																													width: double.infinity,
																													child: Row(
																														children: [
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(10),
																																),
																																margin: const EdgeInsets.only( right: 8),
																																width: 15,
																																height: 15,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(10),
																																	child: Image.network(
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/nhaphno8_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Expanded(
																																child: Container(
																																	width: double.infinity,
																																	child: Text(
																																		"Mark as resolved",
																																		style: TextStyle(
																																			color: Color(0xFF311DA2),
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
																			padding: const EdgeInsets.only( top: 16, bottom: 16, left: 15, right: 15),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 9),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									IntrinsicHeight(
																										child: Container(
																											margin: const EdgeInsets.only( bottom: 8),
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
																																		color: Color(0xFFB6DEF2),
																																	),
																																	padding: const EdgeInsets.only( top: 2, bottom: 2, left: 7, right: 7),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"Resolve Pending",
																																				style: TextStyle(
																																					color: Color(0xFF3020C5),
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
																																	margin: const EdgeInsets.only( right: 19),
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
																												margin: const EdgeInsets.only( bottom: 4),
																												child: Row(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	margin: const EdgeInsets.only( right: 19),
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
																							padding: const EdgeInsets.all(12),
																							margin: const EdgeInsets.only( bottom: 10),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( right: 4),
																										width: 15,
																										height: 15,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/z8590ox3_expires_30_days.png",
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
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 18),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Expanded(
																										child: InkWell(
																											onTap: () { print('Pressed'); },
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
																													margin: const EdgeInsets.only( right: 20),
																													width: double.infinity,
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/q37rnz8a_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Expanded(
																																child: Container(
																																	width: double.infinity,
																																	child: Text(
																																		"Contact User",
																																		style: TextStyle(
																																			color: Color(0xFFB79C91),
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
																									),
																									Expanded(
																										child: InkWell(
																											onTap: () { print('Pressed'); },
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
																													padding: const EdgeInsets.symmetric(vertical: 6),
																													width: double.infinity,
																													child: Row(
																														mainAxisAlignment: MainAxisAlignment.center,
																														children: [
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(10),
																																),
																																margin: const EdgeInsets.only( right: 19),
																																width: 15,
																																height: 15,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(10),
																																	child: Image.network(
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/rit8bnmt_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Text(
																																"Warn User",
																																style: TextStyle(
																																	color: Color(0xFFB79C91),
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
																							width: double.infinity,
																							child: Row(
																								children: [


                                                  //****delete leather wallet page goes to disclaimer */
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
																													padding: const EdgeInsets.only( top: 4, bottom: 4, left: 12, right: 12),
																													margin: const EdgeInsets.only( right: 12),
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
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/7yponr52_expires_30_days.png",
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

                                                  ///***leather wallet mark as resolved goes to resolve reports page */
																									Expanded(
																										child: InkWell(
																											onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboardAfterWarningUser()), 
                                                  );     
                                                      
                                                      },
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
																													padding: const EdgeInsets.only( top: 6, bottom: 6, left: 8, right: 8),
																													width: double.infinity,
																													child: Row(
																														children: [
																															Container(
																																decoration: BoxDecoration(
																																	borderRadius: BorderRadius.circular(10),
																																),
																																margin: const EdgeInsets.only( right: 8),
																																width: 15,
																																height: 15,
																																child: ClipRRect(
																																	borderRadius: BorderRadius.circular(10),
																																	child: Image.network(
																																		"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/xza7y9ow_expires_30_days.png",
																																		fit: BoxFit.fill,
																																	)
																																)
																															),
																															Expanded(
																																child: Container(
																																	width: double.infinity,
																																	child: Text(
																																		"Mark as resolved",
																																		style: TextStyle(
																																			color: Color(0xFF311DA2),
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