import 'package:flutter/material.dart';

//admin can go to deleted item screen and goes back to view item screen
import 'admin_after_del_item.dart';


class AdminDashboardDeletingItem extends StatefulWidget {
	const AdminDashboardDeletingItem({super.key});
	@override
		AdminDashboardDeletingItemState createState() => AdminDashboardDeletingItemState();
	}
class AdminDashboardDeletingItemState extends State<AdminDashboardDeletingItem> {
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
																			padding: const EdgeInsets.symmetric(vertical: 25),
																			margin: const EdgeInsets.only( top: 292, bottom: 319),
																			width: double.infinity,
																			child: Column(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 9),
																						child: Text(
																							"Delete Report",
																							style: TextStyle(
																								color: Color(0xFF0A0A0A),
																								fontSize: 18,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( bottom: 17, left: 24, right: 24),
																						width: double.infinity,
																						child: Text(
																							"Are you sure you want to delete Leather Wallet ? This action cannot be undone. This should only be used for fake or already resolved reports.",
																							style: TextStyle(
																								color: Color(0xFF717182),
																								fontSize: 14,
																							),
																							textAlign: TextAlign.center,
																						),
																					),

                                          //*****DELETE ITEM BUTTON  */
																					InkWell(
																						onTap: () { Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => const AdminDashboardAfterItemIsDeleted()),
                                        );

                                            },
																						child: IntrinsicHeight(
																							child: Container(
																								decoration: BoxDecoration(
																									borderRadius: BorderRadius.circular(10),
																									color: Color(0xFFEC003F),
																									boxShadow: [
																										BoxShadow(
																											color: Color(0x40000000),
																											blurRadius: 4,
																											offset: Offset(0, 4),
																										),
																									],
																								),

																								padding: const EdgeInsets.symmetric(vertical: 7),
																								margin: const EdgeInsets.only( bottom: 9, left: 24, right: 24),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Delete",
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

              //***when clicking cancel it goes back to view item  page */
																					InkWell(
																						onTap: () { Navigator.pop(context);
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
																								padding: const EdgeInsets.symmetric(vertical: 7),
																								margin: const EdgeInsets.symmetric(horizontal: 24),
																								width: double.infinity,
																								child: Column(
																									children: [
																										Text(
																											"Cancel",
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