import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:shop_app/helper/cart_provider.dart';

import 'components/categories.dart';
// import 'components/discount_banner.dart';
import 'components/home_header.dart';
import 'components/popular_product.dart';
import 'components/recomend_product.dart';
// import 'components/special_offers.dart';

class HomeScreen extends StatelessWidget {
  static String routeName = "/home";

  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              HomeHeader(),
              // DiscountBanner(),
              Categories(),
              PopularProducts(),
              RecommendProducts(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
