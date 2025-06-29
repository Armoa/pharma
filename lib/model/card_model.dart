class CartItem {
  final int id;
  final String name;
  final double price;
  final String image;
  int quantity;
  final int? cuponId;

  CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
    this.cuponId,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      image: json['image'],
      quantity: json['quantity'],
      cuponId: json['cupon_id'], // <- debe venir desde el backend
    );
  }
}
