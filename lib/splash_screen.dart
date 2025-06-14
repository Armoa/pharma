import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharma/provider/auth_provider.dart' as local_auth;
import 'package:pharma/screens/home.dart';
import 'package:pharma/screens/login.dart';
import 'package:pharma/services/version.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  late Connectivity _connectivity;
  bool _isChecking = true; // Estado para controlar el chequeo de conectividad

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var connectivityResult = await _connectivity.checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        _checkConnectivityAndSession();
      } else {
        checkForUpdate(context);
      }
    });
  }

  //Verificador de version
  Future<void> checkForUpdate(BuildContext context) async {
    String currentVersion = await getAppVersion();

    if (await isUpdateRequired(currentVersion)) {
      final latestData = await getLatestVersion();
      // Verifica si el contexto todavía es válido antes de mostrar el diálogo.
      if (context.mounted) {
        showUpdateDialog(context, latestData["update_url"]);
        return; // Evita continuar con la ejecución
      } else {
        // print("Contexto no válido, no se muestra el diálogo de actualización");
        return;
      }
    }
    // Solo verificamos la conectividad si NO es necesaria una actualización
    _checkConnectivityAndSession();
  }

  //Verificador de version
  void showUpdateDialog(BuildContext context, String updateUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Align(
            alignment: Alignment.center,
            child: Text(
              "¡Actualización requerida!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          content: Text("Por favor, actualiza la aplicación para continuar."),
          actions: [
            TextButton(
              onPressed: () async {
                Uri uri = Uri.parse(updateUrl);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  throw Exception(
                    "No se pudo abrir el enlace de actualización.",
                  );
                }
              },
              child: Text("Actualizar ahora"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _checkConnectivityAndSession() async {
    var connectivityResult = await _connectivity.checkConnectivity();

    // Aseguramos que connectivityResult se maneje correctamente
    if (connectivityResult.toString().contains('ConnectivityResult.none')) {
      // Manejo de no conexión a Internet
      setState(() {
        _isChecking = false; // Detenemos el indicador de progreso
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No hay conexión a internet'),
            duration: Duration(seconds: 3),
          ),
        );
      });
    } else {
      // Procede a verificar la sesión si hay conexión

      final authProvider = Provider.of<local_auth.AuthProvider>(
        context,
        listen: false,
      );
      await authProvider.loadUser();
      print("Usuario cargado: ${authProvider.user}");
      print("Token: ${authProvider.user?.token}");

      // Verificar si está autenticado por Google (Firebase) o por AuthProvider local
      final isFirebaseUser = FirebaseAuth.instance.currentUser != null;
      final isLocalUser = authProvider.user != null;

      if (isFirebaseUser || isLocalUser) {
        // Usuario autenticado, navegar al home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MyHomePage()),
        );
      } else {
        // Usuario no autenticado, ir al login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }

      // final authProvider = Provider.of<AuthProvider>(context, listen: false);
      // await authProvider.loadUser();
      // print("Usuario cargado: ${authProvider.user}");
      // print("Token: ${authProvider.user?.token}");

      // if (authProvider.user?.token != null &&
      //     authProvider.user!.token.isNotEmpty) {
      //   // Usuario logueado, navegar a MyHomePage
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => const MyHomePage()),
      //   );
      // } else {
      //   // Usuario no logueado, navegar al LoginScreen
      //   Navigator.pushReplacement(
      //     context,
      //     MaterialPageRoute(builder: (_) => const LoginScreen()),
      //   );
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
            _isChecking
                ? const CircularProgressIndicator() // Mostrar progreso mientras verifica
                : GestureDetector(
                  onTap: () {
                    _checkConnectivityAndSession(); // Verificar nuevamente la conexión
                  },
                  child: const Icon(
                    Icons.wifi_off,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
      ),
    );
  }
}
