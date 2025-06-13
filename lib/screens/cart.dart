import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharma/model/card_model.dart';
import 'package:pharma/model/colors.dart';
import 'package:pharma/provider/auth_provider.dart';
import 'package:pharma/provider/cart_provider.dart';
import 'package:pharma/screens/login.dart';
import 'package:pharma/screens/order_confirmation_screen.dart';
// import 'package:pharma/screens/order_confirmation_screen.dart';

import 'package:provider/provider.dart';

final numeroFormat = NumberFormat("#,###", "es_PY");

String numberFormat(String x) {
  List<String> parts = x.toString().split('.');
  RegExp re = RegExp(r'\B(?=(\d{3})+(?!\d))');
  parts[0] = parts[0].replaceAll(re, '.');
  if (parts.length == 1) {
    parts.add('');
  } else {
    parts[1] = parts[1].padRight(2, '0').substring(0, 2);
  }
  return parts.join('');
}

class CartScreenView extends StatelessWidget {
  const CartScreenView({super.key});
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
      backgroundColor: AppColors.blueLight,
      appBar: AppBar(
        backgroundColor: AppColors.blueLight,
        surfaceTintColor: Colors.transparent,
        title: const Text("Mi Carrito"),
      ),
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
                        color: Colors.grey[100],
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
                      color: Colors.grey[100],
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blueDark,
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
                          icon: const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Colors.white,
                          ),

                          label: const Text(
                            "Confirmar Pedido",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
      ),
    );
  }
}
