import 'package:flutter/material.dart';

import 'admin_view_claim_item.dart';
import 'admin_del_claim_confirmed.dart';

class AdminDashboardDeleteClaim  extends StatefulWidget {
	const AdminDashboardDeleteClaim ({super.key});
	@override
		AdminDashboardDeleteClaimState createState() => AdminDashboardDeleteClaimState();
	}
class AdminDashboardDeleteClaimState extends State<AdminDashboardDeleteClaim > {
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
															padding: const EdgeInsets.symmetric(vertical: 305),
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
																			width: double.infinity,
																			child: Column(
																				children: [
																					Container(
																						margin: const EdgeInsets.only( bottom: 8),
																						child: Text(
																							"Delete Claim",
																							style: TextStyle(
																								color: Color(0xFF0A0A0A),
																								fontSize: 18,
																								fontWeight: FontWeight.bold,
																							),
																						),
																					),
																					Container(
																						margin: const EdgeInsets.only( bottom: 16, left: 30, right: 30),
																						width: double.infinity,
																						child: Text(
																							"Are you sure you want to delete the claim for Set of Keys ? This should only be used for false, duplicate, or resolved claims.",
																							style: TextStyle(
																								color: Color(0xFF717182),
																								fontSize: 14,
																							),
																							textAlign: TextAlign.center,
																						),
																					),

                                        //****DELETE CLAIM GO TO DELETE CONFIRM PAGE */
																					InkWell(
																						onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const ClaimDeleteConfirmation()), 
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
																								margin: const EdgeInsets.only( bottom: 9, left: 25, right: 25),
																								width: double.infinity,
																								child: Column(
																									children: [
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

                                          //*******cancel goes back to view keys  */
																					InkWell(
																						onTap: () { Navigator.push(
                                                    context,
                                                    MaterialPageRoute(builder: (context) => const AdminDashboardClaimViewItemScreen2()), 
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
																								padding: const EdgeInsets.symmetric(vertical: 7),
																								margin: const EdgeInsets.symmetric(horizontal: 25),
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