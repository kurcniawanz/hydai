import 'package:flutter/material.dart';
import 'package:shop_app/helper/db_helper.dart';

class CartProvider with ChangeNotifier {
  DBHelper dbHelper = DBHelper();
  int _counter = 0;
  int get counter => _counter;

  void _getPrefsItems() async {
    var cartCount = await dbHelper.getQuantity();
    _counter = cartCount;
  }

  void setCounter() async {
    _counter = await dbHelper.getQuantity();
    notifyListeners();
  }

  int getCounter() {
    _getPrefsItems();
    return _counter;
  }
}
