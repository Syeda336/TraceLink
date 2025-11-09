import 'package:flutter/material.dart';

import 'admin_show_return.dart';
import 'admin_deleteitemask.dart';
//admin can delete the wallet , mark as return and , cancel the screen goes back to lost items screen

class AdminDashboard1ViewItem extends StatefulWidget {
	const AdminDashboard1ViewItem({super.key});
	@override
		AdminDashboard1ViewItemState createState() => AdminDashboard1ViewItemState();
	}
class AdminDashboard1ViewItemState extends State<AdminDashboard1ViewItem> {
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
															padding: const EdgeInsets.symmetric(vertical: 106),
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
																			padding: const EdgeInsets.only( top: 21, bottom: 21, right: 17),
																			width: double.infinity,
																			child: Column(
																				crossAxisAlignment: CrossAxisAlignment.start,
																				children: [
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 8, left: 17),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								crossAxisAlignment: CrossAxisAlignment.start,
																								children: [
																									Container(
																										width: 15,
																										height: 15,
																										child: SizedBox(),
																									),
																									Container(
																										margin: const EdgeInsets.only( top: 8),
																										child: Text(
																											"Item Details",
																											style: TextStyle(
																												color: Color(0xFF0A0A0A),
																												fontSize: 18,
																												fontWeight: FontWeight.bold,
																											),
																										),
																									),


                                                  //****adding navigation back to lost items so pop  */
                                                  GestureDetector( 
                                                      onTap: () {
                                                        // This command goes BACK to the previous screen
                                                        Navigator.pop(context);
                                                      },
                                                      child:
																									        IntrinsicWidth(
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

                                                              //CROSS SIGN TO GO BACK TO LOST ITEMS PAGE
																															child: Image.network(
																																"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/qlqpf1ry_expires_30_days.png",
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
																							"Full information about the reported item",
																							style: TextStyle(
																								color: Color(0xFF717182),
																								fontSize: 14,
																							),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( bottom: 16, left: 25),
																						height: 191,
																						width: double.infinity,
																						child: Image.network(
																							"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/0zvzqyq6_expires_30_days.png",
																							fit: BoxFit.fill,
																						)
																					),
																					IntrinsicHeight(
																						child: Container(
																							margin: const EdgeInsets.only( bottom: 9, left: 25),
																							width: double.infinity,
																							child: Row(
																								mainAxisAlignment: MainAxisAlignment.spaceBetween,
																								children: [
																									Text(
																										"Leather Wallet",
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
																														color: Color(0xFFF2E7FE),
																													),
																													padding: const EdgeInsets.only( top: 2, bottom: 2, left: 9, right: 9),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Lost",
																																style: TextStyle(
																																	color: Color(0xFF8200DA),
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
																					Container(
																						margin: const EdgeInsets.only( bottom: 17, left: 25),
																						child: Text(
																							"Black leather wallet with student ID and credit cards",
																							style: TextStyle(
																								color: Color(0xFF495565),
																								fontSize: 14,
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
																											margin: const EdgeInsets.only( right: 122),
																											child: Text(
																												"Category",
																												style: TextStyle(
																													color: Color(0xFF697282),
																													fontSize: 14,
																												),
																											),
																										),
																										Text(
																											"Date",
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
																								margin: const EdgeInsets.only( bottom: 12, left: 25),
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 93),
																											child: Text(
																												"Accessories",
																												style: TextStyle(
																													color: Color(0xFF101727),
																													fontSize: 16,
																												),
																											),
																										),
																										Text(
																											"Oct 10, 2025",
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
																										IntrinsicWidth(
																											child: IntrinsicHeight(
																												child: Container(
																													margin: const EdgeInsets.only( right: 127),
																													child: Column(
																														crossAxisAlignment: CrossAxisAlignment.start,
																														children: [
																															Text(
																																"Location",
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
																										Text(
																											"Reported By",
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
																								margin: const EdgeInsets.only( bottom: 12, left: 25),
																								child: Row(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Container(
																											margin: const EdgeInsets.only( right: 56),
																											child: Text(
																												"Library, 2nd Floor",
																												style: TextStyle(
																													color: Color(0xFF101727),
																													fontSize: 16,
																												),
																											),
																										),
																										Text(
																											"panda123",
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
																								child: Column(
																									crossAxisAlignment: CrossAxisAlignment.start,
																									children: [
																										Text(
																											"Contact",
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
																					Container(
																						margin: const EdgeInsets.only( bottom: 16, left: 25),
																						child: Text(
																							"256719002@formanite.edu.pk",
																							style: TextStyle(
																								color: Color(0xFF101727),
																								fontSize: 16,
																							),
																						),
																					),

                                          //***adding navigation to mart as return go to return show screen */
																					InkWell(
																						onTap: () { Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const AdminDashboard2ReturnedItemShow()), 
                                        );
                                             },


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
																								margin: const EdgeInsets.only( bottom: 9, left: 25),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/59fajfzk_expires_30_days.png",
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


                                          //***ADDING NAVIGATION TO DELETE THE ITEM AND GO TO DELete DISCLAIMER */
																					InkWell(
																						onTap: () {Navigator.push(
                                                      context,
                                                      MaterialPageRoute(builder: (context) => const AdminDashboardDeletingItem()), 
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
																								margin: const EdgeInsets.only( left: 25),
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
																													"https://storage.googleapis.com/tagjs-prod.appspot.com/v1/W60R4PlhvN/619eo1w4_expires_30_days.png",
																													fit: BoxFit.fill,
																												)
																											)
																										),
																										Text(
																											"Delete Report",
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