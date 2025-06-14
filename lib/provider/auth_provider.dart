import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharma/model/usuario_model.dart';
import 'package:pharma/services/obtener_usuario.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  UsuarioModel? usuario;
  int? userId;
  int? tokenData;
  String? _email;
  String? get email => _email;

  void setUserEmail(String email) {
    _email = email;
    notifyListeners();
  }

  AuthProvider() {
    _initUsuario();
  }

  Future<void> _initUsuario() async {
    usuario = await obtenerUsuarioDesdeMySQL();
    if (usuario != null) {
      userId = usuario?.id;
      _email = usuario?.email;
      notifyListeners();
    }
  }

  UsuarioModel? _user;
  UsuarioModel? get user => _user;
  bool get isAuthenticated => _user != null;

  // ✅ Notificar cambios para actualizar la UI

  void setUserAuthenticated(UsuarioModel user) {
    // _user = user;
    _user = UsuarioModel(
      id: 0,
      email: user.email,
      name: user.name,
      lastName: '',
      photo: '',
      address: '',
      phone: '',
      city: '',
      barrio: '',
      razonsocial: '',
      ruc: '',
      dateBirth: '',
      dateCreated: '',
      token: '',
    );
    notifyListeners();
  }

  // Login para usuario con User y Password
  Future<Map<String, dynamic>?> loginUser(
    String username,
    String password,
  ) async {
    final url = Uri.parse("https://farma.staweno.com/login.php");
    try {
      final response = await http.post(
        url,
        body: {'name': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _user = UsuarioModel.fromJson(data['user']);
        // Aqui se define para ingresar al ID del usuario
        userId = _user!.id;

        // Guardar usuario y token en SharedPreferences

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', json.encode(data['user']));
        await prefs.setBool('isLogged', true);

        // Solo guardar token si existe
        if (data['user']['token'] != null) {
          await prefs.setString('token', data['user']['token']);
        }

        notifyListeners();
        return data;
      } else {
        return {"status": "error", "message": "Error de conexión"};
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Error al conectar con el servidor",
      };
    }
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    final isLogged = prefs.getBool('isLogged') ?? false;
    final tokenData = prefs.getString('token');

    if (userData != null && isLogged) {
      final userJson = json.decode(userData);
      _user = UsuarioModel.fromJson(userJson);
      notifyListeners();
    }

    print("Datos recuperados de SharedPreferences:");
    print("User: $userData");
    print("Token: $tokenData");

    if (userData != null && tokenData != null && tokenData.isNotEmpty) {
      final userJson = json.decode(userData);
      _user = UsuarioModel.fromJson(userJson);
      userId = _user!.id;
      _user!.token = tokenData ?? '';

      // Asegurar que el token se asigna correctamente
      _user = UsuarioModel(
        id: _user!.id,
        name: _user!.name,
        lastName: _user!.lastName,
        email: _user!.email,
        photo: _user!.photo,
        address: _user!.address,
        phone: _user!.phone,
        city: _user!.city,
        barrio: _user!.barrio,
        razonsocial: _user!.razonsocial,
        ruc: _user!.ruc,
        dateBirth: _user!.dateBirth,
        dateCreated: _user!.dateCreated,
        token: tokenData,
      );
      notifyListeners();
    }
  }

  // CERRAR SESSION
  void clearUserData() {
    _user = null;
    userId = null;
    _email = null;
    notifyListeners();
  }

  late BuildContext _context; // ✅ Guardar referencia del contexto
  @override
  void dispose() {
    _logoutSafely();
    super.dispose();
  }

  void _logoutSafely() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AuthProvider>(_context, listen: false).logout();
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('isLogged');
    await prefs.remove('token');
    _user = null;
    notifyListeners();
  }

  // Función para registrar usuarios
  Future<Map<String, dynamic>?> registerUser(
    String username,
    String email,
    String password,
  ) async {
    final url = Uri.parse("https://farma.staweno.com/register.php");
    try {
      final response = await http.post(
        url,
        body: {'name': username, 'email': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData; // 🔥 Retorna un mapa en lugar de un String
      } else {
        return {"status": "error", "message": "Error de conexión"};
      }
    } catch (e) {
      return {
        "status": "error",
        "message": "Error al conectar con el servidor",
      };
    }
  }

  // Verificar cuenta
  Future<String?> verifyAccount(String code) async {
    final url = Uri.parse("https://farma.staweno.com/verify.php?code=$code");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData['message'];
      } else {
        return "Error de conexión";
      }
    } catch (e) {
      return "Error al conectar con el servidor";
    }
  }
}
