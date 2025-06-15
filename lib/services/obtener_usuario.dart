import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharma/model/usuario_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<UsuarioModel?> obtenerUsuarioDesdeMySQL() async {
  final prefs = await SharedPreferences.getInstance();
  final userString = prefs.getString('user');

  if (userString == null) return null;
  final userJson = json.decode(userString);
  final email = userJson['email'];
  if (email == null || email.isEmpty) return null;

  String apiUrl = "https://farma.staweno.com/get_user.php?email=$email";

  var response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);
    if (jsonResponse["status"] != "not_found") {
      return UsuarioModel.fromJson(jsonResponse);
    }
  }
  return null;
}
