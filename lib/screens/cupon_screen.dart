import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pharma/model/colors.dart';
import 'package:pharma/provider/auth_provider.dart';
import 'package:pharma/services/functions.dart';
import 'package:provider/provider.dart';

class CuponesScreen extends StatefulWidget {
  const CuponesScreen({super.key});

  @override
  CuponesScreenState createState() => CuponesScreenState();
}

class CuponesScreenState extends State<CuponesScreen> {
  List<dynamic> cupones = [];
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    final clienteId = Provider.of<AuthProvider>(context, listen: false).userId;
    if (clienteId != null) {
      obtenerCupones();
    }
  }

  Future<void> obtenerCupones() async {
    final clienteId = Provider.of<AuthProvider>(context, listen: false).userId;

    final response = await http.post(
      Uri.parse(
        'https://farma.staweno.com/cupones/obtener_cupones_cliente.php',
      ),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'cliente_id': clienteId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        cupones = data['cupones'];
        cargando = false;
      });
    } else {
      setState(() {
        cargando = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al obtener cupones')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blueLight,
      appBar: AppBar(
        backgroundColor: AppColors.blueLight,
        surfaceTintColor: Colors.transparent,
        title: Text('Mis Cupones'),
      ),
      body:
          cargando
              ? Center(child: CircularProgressIndicator())
              : cupones.isEmpty
              ? Center(child: Text('No tenés cupones activos 😔'))
              : Container(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: Color.fromARGB(255, 255, 255, 255),
                ),
                child: ListView.builder(
                  itemCount: cupones.length,
                  itemBuilder: (context, index) {
                    final cupon = cupones[index];
                    return Container(
                      height: 108,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),

                      child: Stack(
                        children: [
                          // Imagen de fondo
                          Positioned.fill(
                            child: Image.asset(
                              'assets/cupon-background.png',
                              fit: BoxFit.contain,
                            ),
                          ),

                          // Código de descuento (por ejemplo, "W4XZCA8R")
                          Positioned(
                            top: 10,
                            left: 120,
                            child: Text(
                              '${cupon['codigo']}',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // // Monto (por ejemplo, "G. 15.000")
                          Positioned(
                            top: 40,
                            left: 120,
                            child: Text(
                              '₲${numeroFormat.format(cupon['monto'])}',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),

                          // // Mensaje adicional (por ejemplo, "Fijo en carrito")
                          Positioned(
                            top: 76,
                            left: 120,
                            child: Text(
                              '${cupon['tipo']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                          ),

                          // // Fecha de expiración
                          Positioned(
                            bottom: 10,
                            right: 20,
                            child: Text(
                              'Expira: ${cupon['valido_hasta']}',
                              style: TextStyle(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    // Card(
                    //   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    //   child: ListTile(
                    //     title: Text('Cupón: ${cupon['codigo']}'),
                    //     subtitle: Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Text('Tipo: ${cupon['tipo']}'),
                    //         Text(
                    //           'Monto: ₲${numeroFormat.format(cupon['monto'])}',
                    //         ),
                    //         Text('Válido hasta: ${cupon['valido_hasta']}'),
                    //         if (cupon['envio_gratis']) Text('🎁 Envío Gratis'),
                    //       ],
                    //     ),
                    //     leading: Icon(Icons.card_giftcard, color: Colors.green),
                    //   ),
                    // );
                  },
                ),
              ),
    );
  }
}
