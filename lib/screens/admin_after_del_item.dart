import 'package:flutter/material.dart';

import 'admin_claims.dart';
import 'admin_user_reports.dart';
import 'admin_lostitems1.dart';

class AdminDashboardAfterItemIsDeleted extends StatefulWidget {
	const AdminDashboardAfterItemIsDeleted({super.key});
	@override
		AdminDashboardAfterItemIsDeletedState createState() => AdminDashboardAfterItemIsDeletedState();
	}
class AdminDashboardAfterItemIsDeletedState extends State<AdminDashboardAfterItemIsDeleted> {
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
															margin: const EdgeInsets.only( bottom: 25),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( top: 47, bottom: 16, left: 23, right: 23),
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
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/02fwjf6p_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 24, left: 23, right: 35),
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
															padding: const EdgeInsets.only( right: 12),
															margin: const EdgeInsets.only( bottom: 16, left: 12, right: 23),
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
																						color: Color(0x1A000000),
																						blurRadius: 2,
																						offset: Offset(0, 1),
																					),
																				],
																			),
																			padding: const EdgeInsets.only( top: 4, bottom: 4, left: 3, right: 3),
																			margin: const EdgeInsets.only( bottom: 33, left: 19, right: 5),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [

                                          //****GO BACK TO LOST ITEMS PAGE  */
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
																					Expanded(

                                            //ALREADY ON FOUND ITEMS
																						child: InkWell(
																							onTap: () { print('Pressed'); },
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0x4F000000),
																											width: 1,
																										),
																										borderRadius: BorderRadius.circular(10),
																										color: Color(0xFFFFFFFF),
																										boxShadow: [
																											BoxShadow(
																												color: Color(0x40000000),
																												blurRadius: 4,
																												offset: Offset(0, 4),
																											),
																										],
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

																					Expanded(
                                            //***GO TO CLAIMS PAGE */
																						child: InkWell(
																							onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const  AdminDashboardClaimScreen1()), 
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

                                            //***GO TO USER REPORTS PAGE  */
																						child: InkWell(
																							onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboard3UserReports()), 
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
																				color: Color(0xFFFFFFFF),
																				boxShadow: [
																					BoxShadow(
																						color: Color(0x1A000000),
																						blurRadius: 4,
																						offset: Offset(0, 2),
																					),
																				],
																			),
																			padding: const EdgeInsets.symmetric(vertical: 12),
																			margin: const EdgeInsets.only( bottom: 16),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 9, left: 15, right: 15),
																							width: double.infinity,
																							child: Row(
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										decoration: BoxDecoration(
																											borderRadius: BorderRadius.circular(16),
																										),
																										margin: const EdgeInsets.only( right: 17),
																										width: 79,
																										height: 79,
																										child: ClipRRect(
																											borderRadius: BorderRadius.circular(16),
																											child: Image.network(
																												"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/f1smwob1_expires_30_days.png",
																												fit: BoxFit.fill,
																											)
																										)
																									),
																									Expanded(
																										child: IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( right: 28),
																												width: double.infinity,
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 7),
																																width: double.infinity,
																																child: Row(
																																	mainAxisAlignment: MainAxisAlignment.spaceBetween,
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		IntrinsicWidth(
																																			child: IntrinsicHeight(
																																				child: Container(
																																					padding: const EdgeInsets.only( bottom: 1),
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
																																							color: Color(0xFFDCFCE7),
																																						),
																																						padding: const EdgeInsets.only( top: 2, bottom: 2, left: 8, right: 8),
																																						child: Column(
																																							crossAxisAlignment: CrossAxisAlignment.start,
																																							children: [
																																								Text(
																																									"Found",
																																									style: TextStyle(
																																										color: Color(0xFF008235),
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
																																margin: const EdgeInsets.only( bottom: 5),
																																width: double.infinity,
																																child: Column(
																																	children: [
																																		Text(
																																			"Set of keys with blue keychain",
																																			style: TextStyle(
																																				color: Color(0xFF495565),
																																				fontSize: 14,
																																			),
																																		),
																																	]
																																),
																															),
																														),
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Column(
																																	crossAxisAlignment: CrossAxisAlignment.start,
																																	children: [
																																		Text(
																																			"By: ali_aaaa12",
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
																									),
																								]
																							),
																						),
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 13),
																							width: double.infinity,
																							child: Column(
																								crossAxisAlignment: CrossAxisAlignment.end,
																								children: [
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												margin: const EdgeInsets.only( right: 47),
																												child: Row(
																													crossAxisAlignment: CrossAxisAlignment.start,
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
																																		padding: const EdgeInsets.only( top: 4, bottom: 4, left: 11, right: 11),
																																		margin: const EdgeInsets.only( right: 18),
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
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/3u66ik40_expires_30_days.png",
																																							fit: BoxFit.fill,
																																						)
																																					)
																																				),
																																				Text(
																																					"View",
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
																																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/dzdy81zu_expires_30_days.png",
																																							fit: BoxFit.fill,
																																						)
																																					)
																																				),
																																				Text(
																																					"Return",
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
																									margin: const EdgeInsets.only( left: 107),
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
																														"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/u2s1z7hy_expires_30_days.png",
																														fit: BoxFit.fill,
																													)
																												)
																											),
																											Text(
																												"Delete",
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
															padding: const EdgeInsets.symmetric(vertical: 15),
															margin: const EdgeInsets.only( bottom: 202, left: 12, right: 36),
															width: double.infinity,
															child: Column(
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 4, left: 15, right: 15),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					Container(
																						decoration: BoxDecoration(
																							borderRadius: BorderRadius.circular(16),
																						),
																						margin: const EdgeInsets.only( right: 16),
																						width: 79,
																						height: 79,
																						child: ClipRRect(
																							borderRadius: BorderRadius.circular(16),
																							child: Image.network(
																								"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/52v1r6ke_expires_30_days.png",
																								fit: BoxFit.fill,
																							)
																						)
																					),
																					Expanded(
																						child: IntrinsicHeight(
																							child: Container(
																								padding: const EdgeInsets.only( right: 26),
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
																																			"Water Bottle",
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
																																			color: Color(0xFFDBEAFE),
																																		),
																																		padding: const EdgeInsets.only( top: 2, bottom: 2, left: 9, right: 9),
																																		child: Column(
																																			crossAxisAlignment: CrossAxisAlignment.start,
																																			children: [
																																				Text(
																																					"Returned",
																																					style: TextStyle(
																																						color: Color(0xFF1347E5),
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
																												margin: const EdgeInsets.only( bottom: 5),
																												width: double.infinity,
																												child: Column(
																													children: [
																														Text(
																															"Pink water bottle with name tag",
																															style: TextStyle(
																																color: Color(0xFF495565),
																																fontSize: 14,
																															),
																														),
																													]
																												),
																											),
																										),
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( left: 1),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"By: faseehasid12",
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
																			margin: const EdgeInsets.only( bottom: 10),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.end,
																				children: [
																					IntrinsicWidth(
																						child: IntrinsicHeight(
																							child: Container(
																								margin: const EdgeInsets.only( right: 41),
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
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
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/7u7az2w6_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																																Text(
																																	"View",
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
																														padding: const EdgeInsets.only( top: 3, bottom: 3, left: 11, right: 11),
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
																																			"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/mdnudn5f_expires_30_days.png",
																																			fit: BoxFit.fill,
																																		)
																																	)
																																),
																																Text(
																																	"Return",
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
																					padding: const EdgeInsets.only( top: 4, bottom: 4, left: 10, right: 10),
																					margin: const EdgeInsets.only( left: 111),
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
																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/vozzxjgy_expires_30_days.png",
																										fit: BoxFit.fill,
																									)
																								)
																							),
																							Text(
																								"Delete",
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