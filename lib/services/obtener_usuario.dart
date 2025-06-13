import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:pharma/model/usuario_model.dart';

Future<UsuarioModel?> obtenerUsuarioDesdeMySQL() async {
  User? user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  String apiUrl = "https://farma.staweno.com/get_user.php?email=${user.email}";

  var response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != "not_found") {
      return UsuarioModel.fromJson(jsonResponse);
    }
  }
  return null;
}
