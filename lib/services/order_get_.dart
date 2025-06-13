import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharma/model/orders_model.dart';

Future<List<Order>> fetchOrders(int userId) async {
  final url = Uri.parse(
    "https://farma.staweno.com/get_orders.php?user_id=$userId",
  );
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final List ordersJson = jsonData['orders'];
    return ordersJson.map((o) => Order.fromJson(o)).toList();
  } else {
    throw Exception("Error al cargar pedidos");
  }
}
