import 'package:flutter/material.dart';

//admin can go to lost , found , reports , del claim page , view details keys, ''mark return for keys check'

import 'admin_lostitems1.dart';
import 'admin_founditems.dart';
import 'admin_user_reports.dart';
import 'admin_view_claim_item.dart'; //view keys
import 'admin_del_claim_ask.dart';
//wallet imports
import 'admin_viewitem1.dart';
import 'admin_show_return.dart';
import 'admin_deleteitemask.dart';

class AdminDashboardClaimScreen1 extends StatefulWidget {
	const AdminDashboardClaimScreen1({super.key});
	@override
		AdminDashboardClaimScreen1State createState() => AdminDashboardClaimScreen1State();
	}
class AdminDashboardClaimScreen1State extends State<AdminDashboardClaimScreen1> {
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
											padding: const EdgeInsets.only( bottom: 1),
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
															margin: const EdgeInsets.only( bottom: 24),
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
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/umq1ty8s_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																				]
																			),
																		),
																	),
																	IntrinsicHeight(
																		child: Container(
																			margin: const EdgeInsets.only( bottom: 25),
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
															margin: const EdgeInsets.only( left: 23, right: 48),
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
																			padding: const EdgeInsets.only( top: 5, bottom: 5, left: 4, right: 4),
																			margin: const EdgeInsets.only( bottom: 25),
																			width: double.infinity,
																			child: Row(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [

                                          //*****GO TO LOST ITEMS PAGE  */
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


                                          //***go to found items page  */
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


                                          //**already on claims page */
																					Expanded(
																						child: InkWell(
																							onTap: () { print('Pressed'); },
																							child: IntrinsicHeight(
																								child: Container(
																									decoration: BoxDecoration(
																										border: Border.all(
																											color: Color(0x5E000000),
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

                                          //***GO TO USER REPORTS PAGE  */
																					Expanded(
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
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
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
																										Color(0xFF2B7FFF),
																										Color(0xFFAC46FF),
																									],
																								),
																							),
																							padding: const EdgeInsets.symmetric(vertical: 16),
																							margin: const EdgeInsets.only( bottom: 17),
																							width: double.infinity,
																							child: Row(
																								children: [
																									Container(
																										margin: const EdgeInsets.only( left: 16, right: 12),
																										width: 39,
																										height: 39,
																										child: Image.network(
																											"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/yuquntum_expires_30_days.png",
																											fit: BoxFit.fill,
																										)
																									),
																									IntrinsicWidth(
																										child: IntrinsicHeight(
																											child: Container(
																												padding: const EdgeInsets.only( right: 1),
																												child: Column(
																													crossAxisAlignment: CrossAxisAlignment.start,
																													children: [
																														IntrinsicWidth(
																															child: IntrinsicHeight(
																																child: Container(
																																	margin: const EdgeInsets.only( bottom: 2),
																																	child: Column(
																																		crossAxisAlignment: CrossAxisAlignment.start,
																																		children: [
																																			Text(
																																				"Item Claims",
																																				style: TextStyle(
																																					color: Color(0xFFFFFFFF),
																																					fontSize: 16,
																																				),
																																			),
																																		]
																																	),
																																),
																															),
																														),
																														Container(
																															margin: const EdgeInsets.only( left: 1),
																															child: Text(
																																"1 pending claims",
																																style: TextStyle(
																																	color: Color(0xFFFFFEFE),
																																	fontSize: 14,
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
																							padding: const EdgeInsets.only( bottom: 8),
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
																														color: Color(0x1A000000),
																														blurRadius: 4,
																														offset: Offset(0, 2),
																													),
																												],
																											),
																											margin: const EdgeInsets.only( bottom: 13),
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicHeight(
																														child: Container(
																															margin: const EdgeInsets.only( top: 16, left: 16, right: 16),
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/puwoz3gt_expires_30_days.png",
																																				fit: BoxFit.fill,
																																			)
																																		)
																																	),
																																	Expanded(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						IntrinsicHeight(
																																							child: Container(
																																								margin: const EdgeInsets.only( bottom: 9),
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
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Container(
																																									margin: const EdgeInsets.only( bottom: 4),
																																									child: Row(
																																										children: [
																																											IntrinsicWidth(
																																												child: IntrinsicHeight(
																																													child: Container(
																																														margin: const EdgeInsets.only( right: 15),
																																														child: Column(
																																															crossAxisAlignment: CrossAxisAlignment.start,
																																															children: [
																																																Text(
																																																	"Claimed By:",
																																																	style: TextStyle(
																																																		color: Color(0xFF980FFA),
																																																		fontSize: 14,
																																																	),
																																																),
																																															]
																																														),
																																													),
																																												),
																																											),
																																											Text(
																																												"panda_ali",
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
																																																"Found By:",
																																																style: TextStyle(
																																																	color: Color(0xFFE60076),
																																																	fontSize: 14,
																																																),
																																															),
																																														]
																																													),
																																												),
																																											),
																																										),
																																										Text(
																																											"Faseeha123",
																																											style: TextStyle(
																																												color: Color(0xFF495565),
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
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 12, left: 112),
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
																													),
																													IntrinsicHeight(
																														child: Container(
																															margin: const EdgeInsets.only( bottom: 17, left: 10, right: 27),
																															width: double.infinity,
																															child: Row(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [

                                                                  //***go to view details page for keys   */
																																	InkWell(
																																		onTap: () {Navigator.push(
                                                                              context,
                                                                              MaterialPageRoute(builder: (context) => const AdminDashboardClaimViewItemScreen2()), 
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
																																								color: Color(0x40000000),
																																								blurRadius: 4,
																																								offset: Offset(0, 4),
																																							),
																																						],
																																					),
																																					padding: const EdgeInsets.only( top: 3, bottom: 3, left: 11, right: 11),
																																					margin: const EdgeInsets.only( right: 16),
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
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/pchlcx6b_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								)
																																							),
																																							Text(
																																								"View Details",
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


                                                                  //******marking keys as return ? */
																																	Expanded(
																																		child: InkWell(
																																			onTap: () { print('Pressed'); 
                                                                      
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
																																								color: Color(0x40000000),
																																								blurRadius: 4,
																																								offset: Offset(0, 4),
																																							),
																																						],
																																					),
																																					padding: const EdgeInsets.only( top: 3, bottom: 3, left: 11, right: 11),
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
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/v4url8a4_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								)
																																							),
																																							Expanded(
																																								child: Container(
																																									width: double.infinity,
																																									child: Text(
																																										"Mark Returned",
																																										style: TextStyle(
																																											color: Color(0xFF0A0A0A),
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

                                                          //****delete claim ask for keys******* */
																													InkWell(
																														onTap: () { Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => const AdminDashboardDeleteClaim()), 
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
																																				color: Color(0x40000000),
																																				blurRadius: 4,
																																				offset: Offset(0, 4),
																																			),
																																		],
																																	),
																																	padding: const EdgeInsets.only( top: 3, bottom: 3, left: 11, right: 11),
																																	margin: const EdgeInsets.only( bottom: 45, left: 12),
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
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/isabs1sh_expires_30_days.png",
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
																											width: double.infinity,
																											child: Column(
																												crossAxisAlignment: CrossAxisAlignment.start,
																												children: [
																													IntrinsicHeight(
																														child: Container(
																															margin: const EdgeInsets.only( top: 16, left: 16, right: 16),
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
																																				"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/n0gk81eb_expires_30_days.png",
																																				fit: BoxFit.fill,
																																			)
																																		)
																																	),
																																	Expanded(
																																		child: IntrinsicHeight(
																																			child: Container(
																																				margin: const EdgeInsets.only( right: 1),
																																				width: double.infinity,
																																				child: Column(
																																					crossAxisAlignment: CrossAxisAlignment.start,
																																					children: [
																																						IntrinsicWidth(
																																							child: IntrinsicHeight(
																																								child: Container(
																																									margin: const EdgeInsets.only( bottom: 9),
																																									child: Column(
																																										crossAxisAlignment: CrossAxisAlignment.start,
																																										children: [
																																											Text(
																																												"Black Wallet",
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
																																						IntrinsicHeight(
																																							child: Container(
																																								margin: const EdgeInsets.only( bottom: 4),
																																								width: double.infinity,
																																								child: Row(
																																									crossAxisAlignment: CrossAxisAlignment.start,
																																									children: [
																																										Expanded(
																																											child: IntrinsicHeight(
																																												child: Container(
																																													margin: const EdgeInsets.only( right: 14),
																																													width: double.infinity,
																																													child: Column(
																																														children: [
																																															Text(
																																																"Claimed By:",
																																																style: TextStyle(
																																																	color: Color(0xFF980FFA),
																																																	fontSize: 14,
																																																),
																																															),
																																														]
																																													),
																																												),
																																											),
																																										),
																																										Text(
																																											"amna56",
																																											style: TextStyle(
																																												color: Color(0xFF495565),
																																												fontSize: 14,
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
																																									mainAxisAlignment: MainAxisAlignment.center,
																																									children: [
																																										IntrinsicWidth(
																																											child: IntrinsicHeight(
																																												child: Container(
																																													margin: const EdgeInsets.only( right: 18),
																																													child: Column(
																																														crossAxisAlignment: CrossAxisAlignment.start,
																																														children: [
																																															Text(
																																																"Found By:",
																																																style: TextStyle(
																																																	color: Color(0xFFE60076),
																																																	fontSize: 14,
																																																),
																																															),
																																														]
																																													),
																																												),
																																											),
																																										),
																																										Text(
																																											"ahmeddd",
																																											style: TextStyle(
																																												color: Color(0xFF495565),
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
																																								"Verified",
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
																													IntrinsicWidth(
																														child: IntrinsicHeight(
																															child: Container(
																																margin: const EdgeInsets.only( bottom: 12, left: 112),
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
																													),
																													IntrinsicHeight(
																														child: Container(
																															margin: const EdgeInsets.only( bottom: 11, left: 14, right: 14),
																															width: double.infinity,
																															child: Row(
																																crossAxisAlignment: CrossAxisAlignment.start,
																																children: [
																																	Expanded(

                                                                    //**********Wallet view*********/
																																		child: InkWell(
																																			onTap: () { Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(builder: (context) => const AdminDashboard1ViewItem()), 
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
																																								color: Color(0x40000000),
																																								blurRadius: 4,
																																								offset: Offset(0, 4),
																																							),
																																						],
																																					),
																																					padding: const EdgeInsets.only( top: 3, bottom: 3, left: 11, right: 11),
																																					margin: const EdgeInsets.only( right: 17),
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
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/n5yy7o71_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								)
																																							),
																																							Expanded(
																																								child: Container(
																																									width: double.infinity,
																																									child: Text(
																																										"View Details", //CHANGE TO VIEW DETAILS
																																										style: TextStyle(
																																											color: Color(0xFF0A0A0A),
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

                                                          //*******WALLET MARK RETURN SCREEN  */
																																	InkWell(
																																		onTap: () { Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(builder: (context) => const AdminDashboard2ReturnedItemShow()), 
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
																																								color: Color(0x40000000),
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
																																										"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/ueq0d3sm_expires_30_days.png",
																																										fit: BoxFit.fill,
																																									)
																																								)
																																							),
																																							Text(
																																								"Mark Returned",
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

                                                          //****WALLET DELETE DISCLAIMER  */
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
																																				color: Color(0x40000000),
																																				blurRadius: 4,
																																				offset: Offset(0, 4),
																																			),
																																		],
																																	),
																																	padding: const EdgeInsets.only( top: 3, bottom: 3, left: 11, right: 11),
																																	margin: const EdgeInsets.only( bottom: 51, left: 17),
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
																																						"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/mygrqfne_expires_30_days.png",
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