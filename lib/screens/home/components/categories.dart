import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/models/category.dart';
import 'package:shop_app/network/api.dart';
import 'package:shop_app/screens/products/products_screen.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<Category> categories = [];
  @override
  void initState() {
    getCategories();
    super.initState();
  }

  Future<void> getCategories() async {
    var data = {
      "name": "%",
    };
    var res = await Network().auth(data, '/category');
    var body = json.decode(res.body);

    if (body['result']) {
      if (body['data'].isNotEmpty) {
        List<Category> litsdata = [];
        for (var item in body['data']) {
          litsdata.add(
            Category(
                id: item['id'],
                name: item['name'],
                icon: "assets/icons/Game Icon.svg"),
          );
        }

        setState(() {
          categories = litsdata;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          categories.length,
          (index) => CategoryCard(
            icon: categories[index].icon,
            text: categories[index].name,
            press: () {
              Navigator.pushNamed(
                context,
                ProductsScreen.routeName,
                arguments: ProductArguments(
                    title: categories[index].name,
                    name: '%',
                    category: categories[index].name),
              );
            },
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    Key? key,
    required this.icon,
    required this.text,
    required this.press,
  }) : super(key: key);

  final String icon, text;
  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Container(
        width: 80,
        margin: const EdgeInsets.only(right: 4),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFcce235),
                borderRadius: BorderRadius.circular(10),
              ),
              child: SvgPicture.asset(
                icon,
                // ignore: deprecated_member_use
                color: const Color(0xFF083652),
              ),
            ),
            const SizedBox(height: 4),
            Text(text, textAlign: TextAlign.center)
          ],
        ),
      ),
    );
  }
}
