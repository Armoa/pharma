// import 'dart:convert';

// import 'package:flutter/widgets.dart';
// import 'package:http/http.dart' as http;
// import 'package:pharma/provider/auth_provider.dart';
// import 'package:provider/provider.dart';

// Future<void> fetchCuponesAcumulados(BuildContext context, String userId) async {
//   final clienteId = Provider.of<AuthProvider>(context, listen: false).userId;
//   final response = await http.post(
//     Uri.parse(
//       'https://farma.staweno.com/cupones/cupones_acumulados_cliente.php',
//     ),
//     headers: {'Content-Type': 'application/json'},
//     body: jsonEncode({'cliente_id': clienteId}),
//   );

//   // Handle the response as needed
// }
