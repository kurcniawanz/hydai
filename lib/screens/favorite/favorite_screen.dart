import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/product.dart';

import '../../network/api.dart';
import '../cart/cart_screen.dart';
import '../details/details_screen.dart';
import '../home/components/icon_btn_with_counter.dart';
import '../home/components/search_field.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});
  static String routeName = "/favorit";

  @override
  // ignore: library_private_types_in_public_api
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  List<Product> dataProducts = [];

  @override
  void initState() {
    _getproduct();
    super.initState();
  }

  Future<void> _getproduct() async {
    EasyLoading.show(status: 'loading...');

    var data = {
      "sku": "%",
      "name": "%",
      "categ_name": "%",
      "limit": 1000,
      "offset": 0
    };
    var res = await Network().auth(data, '/product');
    var body = json.decode(res.body);

    if (body['result']) {
      EasyLoading.dismiss();

      if (body['data'].isNotEmpty) {
        List<Product> litsdata = [];
        for (var item in body['data']) {
          litsdata.add(
            Product(
              id: 1,
              images: [
                "assets/images/ps4_console_white_1.png",
                "assets/images/ps4_console_white_2.png",
                "assets/images/ps4_console_white_3.png",
                "assets/images/ps4_console_white_4.png",
              ],
              colors: [
                const Color(0xFFF6625E),
                const Color(0xFF836DB8),
                const Color(0xFFDECB9C),
                Colors.white,
              ],
              title: item['name'],
              price: item['list_price'],
              description: item['description_sale'],
              rating: 5,
              isFavourite: true,
              isPopular: true,
            ),
          );
        }

        setState(() {
          dataProducts = litsdata;
        });
      }
    } else {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: SearchField()),
                const SizedBox(width: 16),
                IconBtnWithCounter(
                  svgSrc: "assets/icons/Cart Icon.svg",
                  numOfitem: 3,
                  press: () =>
                      Navigator.pushNamed(context, CartScreen.routeName),
                ),
                // const SizedBox(width: 8),
                // IconBtnWithCounter(
                //   svgSrc: "assets/icons/Bell.svg",
                //   numOfitem: 3,
                //   press: () {},
                // ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: GridView.builder(
                itemCount: dataProducts.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 20,
                  crossAxisSpacing: 16,
                ),
                itemBuilder: (context, index) => ProductCard(
                  product: dataProducts[index],
                  onPress: () => Navigator.pushNamed(
                    context,
                    DetailsScreen.routeName,
                    arguments:
                        ProductDetailsArguments(product: dataProducts[index]),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
