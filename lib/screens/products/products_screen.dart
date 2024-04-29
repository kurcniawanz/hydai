import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
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
      "offset": pageKey,
      "popular": "%",
      "recomend": "%",
    };
    var res = await Network().auth(data, '/product');
    var body = json.decode(res.body);

    final isLastPage = body['data'].length < pageSize;
    List<Product> listdata = [];

    if (body['result']) {
      if (body['data'].isNotEmpty) {
        for (var item in body['data']) {
          listdata.add(
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

        if (isLastPage) {
          pagingController.appendLastPage(listdata);
        } else {
          final nextPageKey = pageKey + listdata.length;
          pagingController.appendPage(listdata, nextPageKey);
        }
      } else {
        pagingController.appendPage(listdata, 0);
      }
    } else {
      pagingController.appendPage(listdata, 0);
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
                  arguments: ProductDetailsArguments(product: item),
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
