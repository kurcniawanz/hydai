import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop_app/network/api.dart';

import '../../../components/product_card.dart';
import '../../../models/product.dart';
import '../../details/details_screen.dart';
import '../../products/products_screen.dart';
import 'section_title.dart';

class RecommendProducts extends StatefulWidget {
  const RecommendProducts({super.key});

  @override
  State<RecommendProducts> createState() => _RecommendProductsState();
}

class _RecommendProductsState extends State<RecommendProducts> {
  List<Product> dataProducts = [];

  @override
  void initState() {
    _getproduct();
    super.initState();
  }

  Future<void> _getproduct() async {
    var data = {
      "sku": "%",
      "name": "%",
      "categ_name": "%",
      "popular": "%",
      "recomend": "1",
      "limit": 10,
      "offset": 0
    };
    var res = await Network().auth(data, '/product');
    var body = json.decode(res.body);

    if (body['result']) {
      if (body['data'].isNotEmpty) {
        List<Product> litsdata = [];
        for (var item in body['data']) {
          litsdata.add(
            Product(
              id: item['id'],
              images: [
                item['link_image'],
                item['link_image'],
                item['link_image'],
                item['link_image'],
              ],
              colors: [
                const Color(0xFFF6625E),
                const Color(0xFF836DB8),
                const Color(0xFFDECB9C),
                Colors.white,
              ],
              title: item['name'],
              price: item['list_price'],
              pricetext: item['list_price_text'],
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SectionTitle(
            title: "Recommend Products",
            press: () {
              Navigator.pushNamed(context, ProductsScreen.routeName);
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              ...List.generate(
                dataProducts.length,
                (index) {
                  if (dataProducts[index].isPopular) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: ProductCard(
                        product: dataProducts[index],
                        onPress: () => Navigator.pushNamed(
                          context,
                          DetailsScreen.routeName,
                          arguments: ProductDetailsArguments(
                              product: dataProducts[index]),
                        ),
                      ),
                    );
                  }

                  return const SizedBox
                      .shrink(); // here by default width and height is 0
                },
              ),
              const SizedBox(width: 20),
            ],
          ),
        )
      ],
    );
  }
}
