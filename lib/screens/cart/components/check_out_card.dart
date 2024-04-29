// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// import '../../../constants.dart';

class CheckoutCard extends StatelessWidget {
  const CheckoutCard({
    Key? key,
    required this.totalPrice,
    required this.onCheckout,
  }) : super(key: key);

  final String totalPrice;
  final Function() onCheckout;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 0,
    );
    var totalPrice2 = num.tryParse(totalPrice)?.toDouble();
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      // height: 174,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(10),
            //       height: 40,
            //       width: 40,
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF5F6F9),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: SvgPicture.asset("assets/icons/receipt.svg"),
            //     ),
            //     const Spacer(),
            //     const Text("Add voucher code"),
            //     const SizedBox(width: 8),
            //     const Icon(
            //       Icons.arrow_forward_ios,
            //       size: 12,
            //       color: kTextColor,
            //     )
            //   ],
            // ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      children: [
                        TextSpan(
                          text: "Rp. ${formatter.format(totalPrice2)}",
                          style: const TextStyle(
                              fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onCheckout,
                    child: const Text(
                      "Check Out",
                      style: TextStyle(color: Color(0xFF083652)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
