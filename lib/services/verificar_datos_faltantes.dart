import 'package:pharma/model/usuario_model.dart';

List<String> verificarDatosFaltantes(UsuarioModel usuario) {
  List<String> datosFaltantes = [];

  if (usuario.phone.isEmpty) datosFaltantes.add("Teléfono");
  if (usuario.lastName.isEmpty) datosFaltantes.add("Apellido");
  if (usuario.address.isEmpty) datosFaltantes.add("Dirección");
  if (usuario.city.isEmpty) datosFaltantes.add("Ciudad");
  if (usuario.barrio.isEmpty) datosFaltantes.add("Barrio");
  if (usuario.razonsocial.isEmpty) datosFaltantes.add("Razón Social");
  if (usuario.ruc.isEmpty) datosFaltantes.add("RUC");

  return datosFaltantes;
}
