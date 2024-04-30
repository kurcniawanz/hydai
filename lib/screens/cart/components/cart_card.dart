import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../constants.dart';
import '../../../models/cart.dart';
import 'package:intl/intl.dart';

class CartCard extends StatelessWidget {
  const CartCard(
      {Key? key,
      required this.cart,
      required this.onAdd,
      required this.onRemove})
      : super(key: key);

  final Cart cart;
  final Function() onAdd;
  final Function() onRemove;

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
            const SizedBox(height: 2),
            Text(
              "Rp. ${formatter.format(cart.productPrice)}",
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: kSecondaryColor,
                  fontSize: 12),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.zero,
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onRemove,
                    icon: const Icon(
                      Icons.remove,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  cart.quantity.toString(),
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.zero,
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onAdd,
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "",
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text:
                        "Rp. ${formatter.format(cart.productPrice! * cart.quantity!)}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: kPrimaryColor),
                  ),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
