import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharma/model/product_model.dart';

// Para Soportar Paginacion
Future<List<Product>> fetchProductsPaginator(int page) async {
  final response = await http.get(
    Uri.parse(
      'https://farma.staweno.com/get_productPagitator.php?page=$page&limit=10',
    ),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar los productos');
  }
}

Future<List<Product>> fetchProductsPaginatorCategory(
  int page,
  String categoryId,
) async {
  final response = await http.get(
    Uri.parse(
      'https://farma.staweno.com/get_product_category.php?page=$page&category_id=${categoryId.toString()}',
    ),
  );

  if (response.statusCode == 200) {
    final List<dynamic> body = jsonDecode(response.body);
    return body.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar productos');
  }
}

Future<List<Product>> fetchProducts() async {
  final response = await http.get(
    Uri.parse('https://farma.staweno.com/get_product.php'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar los productos');
  }
}

Future<List<Product>> fetchProductsFeatured() async {
  final response = await http.get(
    Uri.parse('https://farma.staweno.com/get_product_featured.php'),
  );

  if (response.statusCode == 200) {
    List<dynamic> data = json.decode(response.body);
    return data.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar los productos');
  }
}

// Consulta API de Brand
Future<List<String>?> fetchShowBrand() async {
  final response = await http.get(
    Uri.parse("https://api.staweno.com/get_slider_brand.php?id=7"),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['status'] == 'success') {
      return List<String>.from(data['imagenes']);
    } else {
      print("No hay banners activos.");
      return null;
    }
  } else {
    print("Error en la solicitud: ${response.statusCode}");
    return null;
  }
}
