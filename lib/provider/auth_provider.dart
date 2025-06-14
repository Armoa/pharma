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
  String? get email => _email; //

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
    _user = user;
    _user = UsuarioModel(
      id: 0, // Puedes asignar un ID si lo obtienes desde MySQL
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

  Future<void> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('https://tu-api.com/auth/login.php'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _user = UsuarioModel.fromJson(data['user']);

      // Guardar usuario en almacenamiento local correctamente
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', json.encode(data['user']));
      await prefs.setString('token', _user!.token); // Guarda el token separado

      notifyListeners();
    } else {
      throw Exception('Error de inicio de sesión');
    }
  }

  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    final tokenData = prefs.getString('token');

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
    _user = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.remove('token'); // Elimina el token

    notifyListeners();
  }
}
