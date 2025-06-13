import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharma/model/notification.dart';

class NotificacionesProvider with ChangeNotifier {
  List<Notificacion> _notificaciones = [];
  bool _cargando = false; // Estado de carga

  List<Notificacion> get notificaciones => _notificaciones;
  bool get cargando => _cargando; // Getter para estado de carga

  // **Aquí agregas la función para contar las no leídas**
  int get totalNoLeidas => _notificaciones.where((n) => !n.fueLeida).length;

  Future<void> obtenerNotificaciones(int usuarioId) async {
    _cargando = true; // Inicia carga
    notifyListeners();

    final url = Uri.parse(
      'https://farma.staweno.com/get_notification.php?usuario_id=$usuarioId',
    );
    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = json.decode(respuesta.body);
      _notificaciones =
          datos.map((json) => Notificacion.fromJson(json)).toList();
    } else {
      _notificaciones = [];
    }

    _cargando = false; // Termina carga
    notifyListeners();
  }

  void marcarComoLeida(int id) async {
    final url = Uri.parse('https://farma.staweno.com/marcar_leida.php');
    await http.post(url, body: {'id': id.toString()});

    _notificaciones =
        _notificaciones.map((notificacion) {
          if (notificacion.id == id) {
            return Notificacion(
              id: notificacion.id,
              nombre: notificacion.nombre,
              mensaje: notificacion.mensaje,
              fecha: notificacion.fecha,
              urgente: notificacion.urgente,
              fueLeida: true, // Se actualiza localmente
            );
          }
          return notificacion;
        }).toList();

    notifyListeners(); // Refrescar UI
  }
}
