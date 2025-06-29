import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharma/model/cupon_model.dart';

Future<List<ProductoConCupon>> fetchProductosConCupon() async {
  final response = await http.get(
    Uri.parse('https://farma.staweno.com/cupones/productos_con_cupones.php'),
  );
  final List<dynamic> jsonList = jsonDecode(response.body);

  final productos = jsonList.map((e) => ProductoConCupon.fromJson(e)).toList();
  return productos;
}
