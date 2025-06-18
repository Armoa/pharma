import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharma/model/category_model.dart';

Future<List<Category>> fetchCategories() async {
  final response = await http.get(
    Uri.parse('https://farma.staweno.com/get_categories.php'),
  );

  if (response.statusCode == 200) {
    List<dynamic> body = json.decode(response.body);
    return body.map((json) => Category.fromJson(json)).toList();
  } else {
    throw Exception('Error al cargar las categorías');
  }
}
