class Order {
  final int id;
  final int total;
  final String status;
  final String createdAt;

  Order({
    required this.id,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      total: json['total'],
      status: json['status'],
      createdAt: json['created_at'],
    );
  }
}
