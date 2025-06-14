import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/provider/theme.dart';
import 'package:pharma/screens/home.dart';
import 'package:pharma/screens/login.dart';
import 'package:pharma/screens/my_acount.dart';
import 'package:pharma/screens/wishlist_screen.dart';
import 'package:pharma/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/auth_provider.dart' as local_auth_provider;

class NewDrawer extends StatelessWidget {
  const NewDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final User? user = FirebaseAuth.instance.currentUser;

    final authProvider = Provider.of<local_auth_provider.AuthProvider>(
      context,
      listen: false,
    );
    final nombreUsuario = authProvider.user?.name ?? 'Invitado';
    final emailUsuario = authProvider.user?.email ?? 'Invitado';

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? AppColors.blueBlak
                      : AppColors.blueLight,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      user?.photoURL != null
                          ? NetworkImage(user!.photoURL!)
                          : AssetImage("assets/google_logo.png")
                              as ImageProvider,
                ),
                SizedBox(height: 5),
                Text(
                  nombreUsuario,

                  // user?.displayName ?? "Usuario Invitado",
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColors.blueLight
                            : AppColors.blueBlak,
                    fontSize: 15,
                  ),
                ),
                Text(
                  emailUsuario,
                  style: TextStyle(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? AppColors.blueLight
                            : AppColors.blueBlak,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyHomePage()),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.message),
            title: Text('Mi Cuenta'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyAcount()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite_border),
            title: Text('Mi Favoritos'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WishlistScreen()),
              );
            },
          ),

          ListTile(
            leading: Icon(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode,
            ),
            title: Text(
              Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark
                  ? "Modo día"
                  : "Modo noche",
            ),
            trailing: Transform.scale(
              scale: 0.8,
              child: Switch(
                value: themeProvider.themeMode == ThemeMode.dark,
                onChanged: (value) => themeProvider.toggleTheme(),
              ),
            ),
          ),
          // INICIAR SESSION
          ListTile(
            leading: Icon(
              (FirebaseAuth.instance.currentUser != null ||
                      Provider.of<local_auth_provider.AuthProvider>(
                        context,
                      ).isAuthenticated)
                  ? Icons.logout
                  : Icons.login,
            ),
            title: Text(
              (FirebaseAuth.instance.currentUser != null ||
                      Provider.of<local_auth_provider.AuthProvider>(
                        context,
                      ).isAuthenticated)
                  ? "Cerrar sesión"
                  : "Iniciar sesión",
            ),
            onTap: () async {
              final authService = AuthService();
              final prefs = await SharedPreferences.getInstance();
              final authProvider =
                  Provider.of<local_auth_provider.AuthProvider>(
                    context,
                    listen: false,
                  );

              if (FirebaseAuth.instance.currentUser != null ||
                  authProvider.isAuthenticated) {
                // Cierra sesión en Firebase y Google si aplica
                if (FirebaseAuth.instance.currentUser != null) {
                  authService.signOut(context);
                }

                // Elimina datos guardados en SharedPreferences (usuarios con email/contraseña)
                await prefs.remove('user');
                await prefs.remove('token');

                // Limpiar datos de usuario en AuthProvider
                authProvider.clearUserData();

                // Navegar a LoginScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              }
            },
          ),

          // ListTile(
          //   leading: Icon(
          //     FirebaseAuth.instance.currentUser == null
          //         ? Icons.login
          //         : Icons.logout,
          //   ),
          //   title: Text(
          //     FirebaseAuth.instance.currentUser == null
          //         ? "Iniciar sesión"
          //         : "Cerrar sesión",
          //   ),
          //   onTap: () async {
          //     final authService = AuthService();
          //     final prefs = await SharedPreferences.getInstance();

          //     if (FirebaseAuth.instance.currentUser == null) {
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => LoginScreen()),
          //       );
          //     } else {
          //       // Cierra sesión en Firebase y Google
          //       authService.signOut(context);

          //       // Elimina datos de usuario guardados
          //       await prefs.remove('user');
          //       await prefs.remove('token');

          //       Provider.of<local_auth_provider.AuthProvider>(
          //         context,
          //         listen: false,
          //       ).clearUserData();

          //       // Navegar al LoginScreen sin opción de volver atrás
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (_) => const LoginScreen()),
          //       );
          //     }
          //   },
          // ),
          ListTile(
            title: Text("Cerrar Applicacion"),
            leading: Icon(Icons.close),
            onTap: () => exit(0),
          ),
        ],
      ),
    );
  }
}
