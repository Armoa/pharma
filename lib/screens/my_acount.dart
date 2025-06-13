import 'package:flutter/material.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/provider/auth_provider.dart';
import 'package:pharma/screens/address_screen.dart';
// import 'package:pharma/screens/my_order.dart';
import 'package:pharma/screens/notification_screen.dart';
import 'package:pharma/screens/orders_screen.dart';
import 'package:pharma/screens/perfil_screen.dart';
import 'package:pharma/services/logout_user.dart';
import 'package:pharma/services/obtener_usuario.dart';
import 'package:pharma/widget/appbar.dart';
import 'package:pharma/widget/drawer.dart';
import 'package:shimmer/shimmer.dart';

class MyAcount extends StatefulWidget {
  const MyAcount({super.key});

  @override
  State<MyAcount> createState() => _MyAcountState();
}

class _MyAcountState extends State<MyAcount> {
  String? _imagenPerfilUrl;
  String? _nombrePerfil;
  int? _idUser;

  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    // Cargar datos iniciales del perfil
    _cargarDatosPerfil();
  }

  Future<void> _cargarDatosPerfil() async {
    final datosPerfil = await obtenerUsuarioDesdeMySQL();

    // Rellenar los controladores con los datos obtenidos
    setState(() {
      _nombrePerfil = datosPerfil?.name;
      _imagenPerfilUrl = datosPerfil?.photo;
      _idUser = datosPerfil?.id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueAcua,
      appBar: const NewAppBar(),
      drawer: const NewDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: AppColors.white,
        ),
        child: SingleChildScrollView(
          // Por si el contenido es más largo que la pantalla
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .stretch, // Para que los bloques se estiren horizontalmente
              children: <Widget>[
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(52.0),
                        border: Border.all(
                          color: const Color.fromARGB(255, 253, 226, 229),
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage:
                              _imagenPerfilUrl != null
                                  ? NetworkImage(_imagenPerfilUrl!)
                                  : null,
                          child:
                              _imagenPerfilUrl == null
                                  ? Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: CircleAvatar(
                                      radius: 40,
                                      backgroundColor: Colors.grey[300],
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Hola, ", style: TextStyle(fontSize: 14)),
                        SizedBox(
                          child: Text(
                            "$_nombrePerfil",
                            style: const TextStyle(
                              fontSize: 20,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _widgetBloque1(context),
                const SizedBox(height: 20),
                _widgetBloque2(context, _idUser),
                const SizedBox(height: 20),
                _widgetBloque3(context),

                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.blueAcua,
                        ),
                        onPressed: () async {
                          await logoutUser(context);
                        },
                        icon: const Icon(
                          Icons.logout,
                          color: Colors.white,
                          size: 24,
                        ), // Aquí defines el icono que quieres mostrar
                        label: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            "Cerrar sesión",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Bloque 1
Widget _widgetBloque1(context) {
  return Card(
    elevation: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Mi Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.place),
              title: const Text('Direcciones'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddressScreen(),
                  ),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Mis Facturas'),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ],
    ),
  );
}

// Bloque 2
Widget _widgetBloque2(BuildContext context, dynamic idUser) {
  return Card(
    elevation: 0,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              leading: const Icon(Icons.payment_sharp),
              title: const Text('Métodos de Pago'),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.list_rounded),
              title: const Text('Mis Pedidos'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrdersScreen(userId: idUser),
                  ),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ],
    ),
  );
}

// Bloque 3
Widget _widgetBloque3(BuildContext context) {
  return Card(
    elevation: 0,
    child: Column(
      children: [
        ListView(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text(
                'Alertas y notificaciones',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(),
                  ),
                );
              },
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text(
                'Información del servicio',
                style: TextStyle(fontSize: 14),
              ),
              onTap: () {},
              trailing: const Icon(Icons.arrow_forward_ios_outlined),
            ),
          ],
        ),
      ],
    ),
  );
}
