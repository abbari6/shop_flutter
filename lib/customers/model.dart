class Customer {
  final String id;
  final String name;
  final int balance;
  final List<Product> product;
  Customer(
      {required this.id,
      required this.name,
      required this.balance,
      required this.product
      });
  factory Customer.fromJson(Map<String, dynamic> data) {
    final id = data['_id'] as String;
    final name = data['name'] as String;
    final balance = data['balance'] as int;
    final customerId = data['customerId'] as String;
    final product = data['products'] as List<dynamic>?;
    final products = product != null
        ? product.map((p) => Product.fromJson(p)).toList()
        : <Product>[];
    return Customer(
        id: id,
        name: name,
        balance: balance,
        product: products);
  }
}

class Product {
  final String id;
  final String name;
  final int price;

  Product({required this.id, required this.name, required this.price});

  factory Product.fromJson(Map<String, dynamic> data) {
    final id = data['_id'] as String;
    final name = data['name'] as String;
    final price = data['price'] as int;
    return Product(id: id, name: name, price: price);
  }
}
