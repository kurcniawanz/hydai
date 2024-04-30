// import 'dart:convert';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/helper/cart_provider.dart';
import 'package:shop_app/helper/db_helper.dart';
import 'package:shop_app/models/payment_method.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/network/api.dart';
// import 'package:shop_app/screens/init_screen.dart';

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
  String totalPrice = "0";
  final TextEditingController dateController = TextEditingController();
  String dateValue = "";
  PaymentMethod? paymentMethod;
  var paymentMethods = List<PaymentMethod>.empty();

  @override
  void initState() {
    getCarts();
    getPaymentMethods();
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
    if (paymentMethod == null) {
      showFailedDialog(message: 'Choose Payment Method');
      return;
    }
    if (dateValue.isEmpty) {
      showFailedDialog(message: 'Choose Pick Up Date');
      return;
    }

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
      "date_pickup": dateValue,
      "payment_method": paymentMethod!.id,
      "note": "",
      "det_orders": products
    };
    await Network().auth(data, '/checkout');
    EasyLoading.dismiss();
    showSuccessDialog();
  }

  void addCart(Cart cart) {
    dbHelper
        .insert(
      Cart(
        id: cart.id,
        productId: cart.productId,
        productName: cart.productName,
        productPrice: cart.productPrice,
        quantity: 1,
        image: cart.image,
      ),
    )
        .then((value) {
      getCarts();
    });
  }

  void removeCart(Cart cart) {
    if (cart.quantity! > 1) {
      dbHelper
          .remove(
        Cart(
          id: cart.id,
          productId: cart.productId,
          productName: cart.productName,
          productPrice: cart.productPrice,
          quantity: cart.quantity! - 1,
          image: cart.image,
        ),
      )
          .then((value) {
        getCarts();
      });
    }
  }

  Future<void> getPaymentMethods() async {
    var data = {
      "name": "%",
    };
    var res = await Network().auth(data, '/payment_method');
    var body = json.decode(res.body);

    if (body['result']) {
      if (body['data'].isNotEmpty) {
        List<PaymentMethod> litsdata = [];
        for (var item in body['data']) {
          litsdata.add(
            PaymentMethod(id: item['id'], name: item['name']),
          );
        }

        setState(() {
          paymentMethods = litsdata;
        });
      }
    }
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

  void showFailedDialog({required String message}) {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text(
          'Hydai',
        ),
        content: SizedBox(
          width: 150,
          height: 40,
          child: Center(child: Text(message)),
        ),
        actions: [
          SizedBox(
            width: 80,
            height: 30,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () => Navigator.pop(context, 'OK'),
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
              child: CartCard(
                cart: carts[index],
                onAdd: () => addCart(carts[index]),
                onRemove: () => removeCart(carts[index]),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: InputDecorator(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PaymentMethod>(
                  isExpanded: true,
                  value: paymentMethod,
                  hint: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text('Payment Method'),
                  ),
                  items: paymentMethods.map((PaymentMethod value) {
                    return DropdownMenuItem<PaymentMethod>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(value.name),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    paymentMethod = value;
                    setState(() {});
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () async {
              var date = await showDatePicker(
                context: context,
                firstDate: DateTime.now(),
                lastDate: DateTime(2050),
              );
              if (date != null) {
                final formatter = DateFormat('E, dd MMM yyyy');
                dateController.text = formatter.format(date);
                dateValue = date.toString();
              }
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AbsorbPointer(
                child: TextField(
                  controller: dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: const InputDecoration(
                    labelText: "Pick Up Date",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    suffixIcon: Icon(Icons.calendar_month),
                  ),
                ),
              ),
            ),
          ),
          CheckoutCard(
            totalPrice: totalPrice,
            onCheckout: checkout,
          ),
        ],
      ),
    );
  }
}
