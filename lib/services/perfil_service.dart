import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pharma/model/usuario_model.dart';

class PerfilService {
  // Crear una Nueva Ubicación adicionales
  Future<bool> crearUbicacion(UbicacionModel nuevaUbicacion) async {
    String apiUrl = "https://farma.staweno.com/add_address.php";
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(nuevaUbicacion.toJson()), // Convertir modelo a JSON
    );

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse["status"] ==
          "success"; // Retorna `true` si se guardó correctamente
    }
    return false;
  }

  // Funcion Otener datos del Perfil
  Future<Map<String, dynamic>> obtenerDatosPerfil(String token) async {
    final url = Uri.parse(
      'https://piletasyjuguetes.com/wp-json/ubicaciones/v1/perfil',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as Map<String, dynamic>;
    } else {
      print('Error al obtener datos del perfil:');
      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      throw Exception('Error al obtener datos del perfil');
    }
  }

  // // Actualizar foto de perfil
  Future<bool> cargarImagenPerfil(String email, XFile imagen) async {
    String apiUrl = "https://farma.staweno.com/update_profile_picture.php";

    var request = http.MultipartRequest("POST", Uri.parse(apiUrl));
    request.fields["email"] = email;
    request.files.add(await http.MultipartFile.fromPath("imagen", imagen.path));

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("Código de respuesta: ${response.statusCode}");
    print("Respuesta API: $responseBody");

    var jsonResponse = jsonDecode(responseBody);
    return jsonResponse["status"] == "success";
  }
}
