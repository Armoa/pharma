import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

Future<bool> actualizarUsuarioEnMySQL(
  String name,
  String lastName,
  String email,
  String address,
  String city,
  String barrio,
  String phone,
  String razonsocial,
  String ruc,
  String dateBirth,
) async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return false;

  String apiUrl = "https://farma.staweno.com/update_user.php";
  Map<String, String> userData = {
    "name": name,
    "last_name": lastName,
    "email": user.email?.isNotEmpty == true ? user.email! : "sin_email",
    "address": address,
    "city": city,
    "barrio": barrio,
    "phone": phone,
    "razonsocial": razonsocial,
    "ruc": ruc,
    "date_birth": dateBirth,
  };

  print("Datos enviados: ${jsonEncode(userData)}");

  var response = await http.post(
    Uri.parse(apiUrl),
    body: jsonEncode(userData),
    headers: {"Content-Type": "application/json"},
  );

  print("Código de respuesta: ${response.statusCode}");
  print("Respuesta API: ${response.body}");

  // Verificar si la respuesta está vacía
  if (response.body.isEmpty) {
    print("Error: La respuesta de la API está vacía.");
    return false;
  }

  var jsonResponse = jsonDecode(response.body);
  return jsonResponse["status"] == "success";
}
