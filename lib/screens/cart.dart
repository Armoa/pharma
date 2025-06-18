import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharma/model/card_model.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/model/usuario_model.dart';
import 'package:pharma/provider/auth_provider.dart';
import 'package:pharma/provider/cart_provider.dart';
import 'package:pharma/screens/login.dart';
import 'package:pharma/screens/order_confirmation_screen.dart';
import 'package:pharma/screens/perfil_screen.dart';
import 'package:pharma/services/functions.dart';
import 'package:pharma/services/obtener_usuario.dart';
import 'package:pharma/services/verificar_datos_faltantes.dart';
// import 'package:pharma/screens/order_confirmation_screen.dart';

import 'package:provider/provider.dart';

final numeroFormat = NumberFormat("#,###", "es_PY");

class CartScreenView extends StatefulWidget {
  const CartScreenView({super.key});

  @override
  State<CartScreenView> createState() => _CartScreenViewState();
}

class _CartScreenViewState extends State<CartScreenView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verificarPerfilUsuario(context);
    });
  }

  Future<void> verificarPerfilUsuario(BuildContext context) async {
    UsuarioModel? usuario = await obtenerUsuarioDesdeMySQL();
    if (usuario == null) return;

    List<String> datosFaltantes = verificarDatosFaltantes(usuario);

    if (datosFaltantes.isNotEmpty) {
      mostrarPopup(context, datosFaltantes);
    }
  }

  void mostrarPopup(BuildContext context, List<String> datosFaltantes) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Actualiza tu perfil"),
          content: Text("Falta completar: ${datosFaltantes.join(", ")}"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cerrar"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: Text("Actualizar"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    // Accede al estado del carrito
    final cartProvider = Provider.of<CartProvider>(context);

    final List<CartItem> cartItems = cartProvider.cartItems;
    // final cartItems = cartProvider.cartItems;

    // Calcular subtotal, envío y total
    final subtotal = cartItems.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity, // Ya es un double
    );
    const shippingCost = 0; // Costo de envío fijo
    final total = subtotal + shippingCost;

    return Scaffold(
      appBar: AppBar(title: const Text("Mi Carrito")),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          color: Color.fromARGB(255, 255, 255, 255),
        ),
        child:
            cartItems.isEmpty
                ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_very_dissatisfied,
                        size: 90,
                        color: Colors.blueGrey,
                      ),
                      Text(
                        "¡Tu carrito está vacío!",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                )
                : Column(
                  children: [
                    // Lista de productos en el carrito
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final CartItem item = cartItems[index];

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Row(
                                children: [
                                  // Imagen del producto con bordes redondeados
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      item.image,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Información del producto
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "₲ ${numeroFormat.format(item.price)}",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: AppColors.blueDark,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Botones para modificar la cantidad
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white, // Color del fondo
                                      borderRadius: BorderRadius.circular(22),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color.fromARGB(30, 0, 0, 0),
                                          spreadRadius: 1,
                                          blurRadius: 4, // Difuminado
                                          offset: Offset(
                                            2,
                                            2,
                                          ), // Desplazamiento (horizontal, vertical)
                                        ),
                                      ],
                                    ),

                                    child: Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.add, size: 18),
                                          onPressed: () {
                                            cartProvider.addToCart(item, 1);
                                          },
                                        ),
                                        Text(
                                          "${item.quantity}",
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                        IconButton(
                                          icon: Icon(
                                            item.quantity > 1
                                                ? Icons.remove
                                                : Icons.delete,
                                            size: 18,
                                          ),
                                          onPressed: () {
                                            if (item.quantity > 1) {
                                              cartProvider.addToCart(item, -1);
                                            } else {
                                              cartProvider.removeFromCart(
                                                item.id,
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Resumen del carrito
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? AppColors.blueBlak
                                : Colors.white,
                        border: const Border(
                          top: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Subtotal:",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "₲. ${numberFormat(subtotal.toStringAsFixed(0).toString())}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Envío:",
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                "₲. ${numberFormat(shippingCost.toStringAsFixed(0))}",
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "₲. ${numberFormat(total.toStringAsFixed(0).toString())}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Botón para finalizar compra
                    Container(
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? AppColors.blueBlak
                              : Colors.white,
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 40),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : AppColors.blueDark,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                          ),
                          onPressed: () {
                            if (!authProvider.isAuthenticated) {
                              // Mostrar mensaje con ScaffoldMessenger
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Para enviar el pedido debes iniciar sesión',
                                  ),
                                  duration: Duration(
                                    seconds: 2,
                                  ), // Duración del mensaje
                                ),
                              );

                              // Navegar a la pantalla de inicio de sesión
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  // ignore: prefer_const_constructors
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            } else {
                              // Usuario logueado, proceder con la navegación
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => OrderConfirmationScreen(
                                        cartItems: cartItems,
                                        totalAmount: total,
                                      ),
                                ),
                              );
                            }
                          },
                          iconAlignment: IconAlignment.end,
                          icon: Icon(
                            Icons.arrow_forward_ios_rounded,
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                    ? AppColors.blueBlak
                                    : Colors.white,
                          ),

                          label: Text(
                            "Confirmar Pedido",
                            style: TextStyle(
                              fontSize: 18,
                              color:
                                  Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? AppColors.blueBlak
                                      : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}
