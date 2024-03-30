import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shop_app/components/product_card.dart';
import 'package:shop_app/models/product.dart';

import '../../network/api.dart';
import '../details/details_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  static String routeName = "/products";

  @override
  // ignore: library_private_types_in_public_api
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  late ProductArguments? args;
  static const pageSize = 10;
  final PagingController<int, Product> pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    args = ModalRoute.of(context)!.settings.arguments as ProductArguments?;
    args ??= ProductArguments(title: 'Products', name: '%', category: '%');
    pagingController.addPageRequestListener((pageKey) {
      _getproduct(pageKey);
    });

    super.didChangeDependencies();
  }

  Future<void> _getproduct(int pageKey) async {
    var data = {
      "sku": "%",
      "name": args?.name,
      "categ_name": args?.category,
      "limit": pageSize,
      "offset": pageKey
    };
    var res = await Network().auth(data, '/product');
    var body = json.decode(res.body);

    final isLastPage = body['data'].length < pageSize;

    if (body['result']) {
      if (body['data'].isNotEmpty) {
        List<Product> listdata = [];
        for (var item in body['data']) {
          listdata.add(
            Product(
              id: item['id'],
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

        if (isLastPage) {
          pagingController.appendLastPage(listdata);
        } else {
          final nextPageKey = pageKey + listdata.length;
          pagingController.appendPage(listdata, nextPageKey);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(args!.title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: PagedGridView<int, Product>(
            pagingController: pagingController,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.7,
              mainAxisSpacing: 20,
              crossAxisSpacing: 16,
            ),
            builderDelegate: PagedChildBuilderDelegate<Product>(
              itemBuilder: (context, item, index) => ProductCard(
                product: item,
                onPress: () => Navigator.pushNamed(
                  context,
                  DetailsScreen.routeName,
                  arguments:
                      ProductDetailsArguments(product: item),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductArguments {
  final String title;
  final String name;
  final String category;

  ProductArguments(
      {required this.title, required this.name, required this.category});
}
