import 'product.dart';

class Cart {
  late final int? id;
  final String? productId;
  final String? productName;
  final double? productPrice;
  final int? quantity;
  final String? image;

  Cart(
      {required this.id,
      required this.productId,
      required this.productName,
      required this.productPrice,
      required this.quantity,
      required this.image});

  Cart.fromMap(Map<dynamic, dynamic> data)
      : id = data['id'],
        productId = data['productId'],
        productName = data['productName'],
        productPrice = data['productPrice'],
        quantity = (data['quantity']),
        image = data['image'];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productPrice': productPrice,
      'quantity': quantity,
      'image': image,
    };
  }
}
