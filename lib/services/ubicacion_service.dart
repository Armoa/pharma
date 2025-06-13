import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pharma/model/usuario_model.dart';
import 'package:pharma/services/obtener_usuario.dart';

Future<List<UbicacionModel>> obtenerUbicaciones() async {
  print("Iniciando carga de ubicaciones... 🚀");

  UsuarioModel? usuario = await obtenerUsuarioDesdeMySQL();
  int? userId = usuario?.id;
  if (userId == null) return [];

  String apiUrl = "https://farma.staweno.com/get_address.php?id=$userId";
  var response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    var jsonResponse = jsonDecode(response.body);

    print("Respuesta JSON: $jsonResponse");

    if (jsonResponse is List) {
      List<UbicacionModel> ubicaciones =
          jsonResponse.map((json) {
            return UbicacionModel.fromJson(json);
          }).toList();

      print("Ubicaciones cargadas: ${ubicaciones.map((u) => u.id).toList()}");
      return ubicaciones;
    }
  }

  return [];
}
