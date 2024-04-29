import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../constants.dart';
import '../../../models/cart.dart';
import 'package:intl/intl.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.decimalPatternDigits(
      locale: 'en_us',
      decimalDigits: 0,
    );
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(cart.image.toString()),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200.0,
              child: AutoSizeText(
                cart.productName.toString(),
                style: const TextStyle(fontSize: 13.0),
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "${cart.quantity} x ",
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                      text: "Rp. ${formatter.format(cart.productPrice)}",
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, color: kPrimaryColor)),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
