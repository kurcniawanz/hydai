import 'package:path_provider/path_provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    await db.execute(
        'CREATE TABLE cart(id INTEGER PRIMARY KEY, productId VARCHAR UNIQUE, productName TEXT, productPrice REAL, quantity INTEGER, image TEXT)');
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;

    var queryResult =
        await dbClient!.rawQuery('SELECT * FROM cart WHERE id="${cart.id}"');
    var result = queryResult.map((result) => Cart.fromMap(result));

    if (queryResult.isEmpty) {
      await dbClient.insert('cart', cart.toMap());
    } else {
      await dbClient.update(
          'cart', {'quantity': result.first.quantity! + cart.quantity!},
          where: "id = ?", whereArgs: [cart.id]);
    }

    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult =
        await dbClient!.query('cart');
    return queryResult.map((result) => Cart.fromMap(result)).toList();
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> getQuantity() async {
    var dbClient = await database;
    int? count = Sqflite.firstIntValue(
        await dbClient!.rawQuery('SELECT COUNT(*) FROM cart'));
    return count ?? 0;
  }

  Future<int> clear() async {
    var dbClient = await database;
    return await dbClient!.rawDelete("DELETE FROM cart");
  }
}
