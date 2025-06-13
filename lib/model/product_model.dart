class Product {
  final int id;
  final String name;
  final String description;
  final String shortDescription;
  final String price;
  final String image;
  final int featured;
  final String gal1;
  final String gal2;
  final String gal3;
  final int stock;
  final int idUser;
  final String categoryName;
  final String createDate;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.shortDescription,
    required this.price,
    required this.image,
    required this.featured,
    required this.gal1,
    required this.gal2,
    required this.gal3,
    required this.stock,
    required this.idUser,
    required this.categoryName,
    required this.createDate,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      shortDescription: json['short_description'] ?? '',
      price: json['price'],
      image: json['image'] ?? '',
      featured: json['featured'] ?? 0,
      gal1: json['gal1'] ?? '',
      gal2: json['gal2'] ?? '',
      gal3: json['gal3'] ?? '',
      stock: json['stock'] ?? 0,
      idUser: json['id_user'] ?? 0,
      categoryName: json['category_name'] ?? '',
      createDate: json['create_date'] ?? '',
    );
  }
}
