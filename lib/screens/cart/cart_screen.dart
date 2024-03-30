import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/cart_provider.dart';
import 'package:shop_app/helper/db_helper.dart';
import 'package:shop_app/network/api.dart';
import 'package:shop_app/screens/init_screen.dart';

import '../../models/cart.dart';
import 'components/cart_card.dart';
import 'components/check_out_card.dart';

class CartScreen extends StatefulWidget {
  static String routeName = "/cart";

  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  DBHelper dbHelper = DBHelper();
  List<Cart> carts = [];
  String totalPrice = "\$0";

  @override
  void initState() {
    getCarts();
    super.initState();
  }

  Future<void> getCarts() async {
    carts = await dbHelper.getCartList();
    updatePrice();
    setState(() {});
  }

  void updatePrice() {
    double price = carts.fold(
        0, (sum, item) => sum + (item.productPrice! * item.quantity!));
    totalPrice = "$price";
    setState(() {});
  }

  Future<void> checkout() async {
    EasyLoading.show(status: 'loading...');

    SharedPreferences localStorage = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('y-MM-dd HH:mm').format(now);

    var products = [];
    for (var cart in carts) {
      products.add({
        'product_id': [cart.productId, cart.productName],
        'qty': cart.quantity,
        'price': cart.productPrice,
      });
    }

    var data = {
      "partner_id": localStorage.getString('id_user'),
      "date_order": formattedDate,
      "note": "",
      "det_orders": products
    };
    await Network().auth(data, '/checkout');
    EasyLoading.dismiss();
    showSuccessDialog();
  }

  void showSuccessDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Hydai',
        ),
        content: const SizedBox(
          width: 150,
          height: 40,
          child: Center(child: Text('Checkout Success')),
        ),
        actions: [
          SizedBox(
            width: 80,
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () async {
                await dbHelper.clear().then((value) {
                  final cartProvider =
                      Provider.of<CartProvider>(context, listen: false);
                  cartProvider.setCounter();
                  Navigator.pop(context, 'OK');
                  Navigator.pop(context);
                });
              },
              child: const Text('OK'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${carts.length} items",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          itemCount: carts.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: Key(carts[index].id.toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                final cartProvider =
                    Provider.of<CartProvider>(context, listen: false);
                setState(() {
                  dbHelper.deleteCartItem(carts[index].id!);
                  carts.removeAt(index);
                  cartProvider.setCounter();
                  updatePrice();
                });
              },
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Spacer(),
                    SvgPicture.asset("assets/icons/Trash.svg"),
                  ],
                ),
              ),
              child: CartCard(cart: carts[index]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CheckoutCard(
        totalPrice: totalPrice,
        onCheckout: checkout,
      ),
    );
  }
}
